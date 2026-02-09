# BaseIOSApp – Cấu trúc dự án & Hướng dẫn sử dụng từng folder

> Tài liệu mô tả **trách nhiệm** và **cách sử dụng** từng thư mục và file trong project. Dùng làm instruction để làm việc với từng phần của codebase.

**Cập nhật:** 2026-02-07

---

## Tổng quan kiến trúc

- **App:** Khởi động ứng dụng, cấu hình, Dependency Injection (DI).
- **Core:** Network, Storage, Security, Logging, Error handling, Performance, Sync, Push, Background.
- **UIFoundation:** Design system, Navigation (Coordinator, Router, DeepLink), UIKit base & components, SwiftUI base & components, Accessibility.
- **Features:** Các feature module (Auth, User, Feature template) theo cấu trúc Domain / Data / Presentation / DI.
- **Resources:** Assets, Localization, SwiftGen generated.
- **Config:** Build configuration (.xcconfig).
- **CI:** Fastlane, GitHub Actions, scripts test/lint.
- **Tests:** Unit tests theo từng layer/feature.

---

## 1. App

Điểm vào ứng dụng: lifecycle, cấu hình, đăng ký DI.

### 1.1 App/Application

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **AppDelegate.swift** | Lifecycle app (didFinishLaunching, willTerminate); đăng ký push (didRegisterForRemoteNotifications, didFailToRegister); có thể schedule background tasks. | Gọi `AppBootstrapper.bootstrap()` trong `didFinishLaunching`. Không đặt logic nghiệp vụ nặng ở đây. |
| **SceneDelegate.swift** | Lifecycle scene (sceneWillEnterForeground, sceneDidEnterBackground); tạo window, set root; gọi `AppCoordinator.start()`; khi vào foreground gọi `SyncManager.triggerSync()`, khi vào background schedule BG refresh. | Root UI được điều khiển bởi AppCoordinator. Cấu hình trong Info.plist (UISceneConfiguration). |
| **AppBootstrapper.swift** | Một điểm khởi tạo: đăng ký DI (`DIAssembler.assemble`), cấu hình Logger, setup background tasks, setup push. | Gọi **đúng một lần** trong `AppDelegate.didFinishLaunchingWithOptions`. |

### 1.2 App/Configuration

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **AppEnvironment.swift** | Định nghĩa môi trường (dev, staging, production, mock); `current` từ BuildConfiguration; cung cấp `baseURL`, `apiKey`, `enableLogging`. | Dùng `AppEnvironment.current.baseURL` cho API, kiểm tra `.mock` để bật mock server. |
| **BuildConfiguration.swift** | Đọc giá trị từ Info.plist / .xcconfig: API_BASE_URL, ENABLE_LOGGING, ENABLE_MOCK_SERVER, bundleID, isDebug. | Các layer khác không đọc plist trực tiếp; dùng BuildConfiguration hoặc AppEnvironment. |
| **AppConstants.swift** | Hằng số toàn app (timeout, key storage, tên notification, v.v.). | Tham chiếu khi cần giá trị cố định (key cache, user defaults key, v.v.). |

### 1.3 App/DI

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **DIContainer.swift** | Container Swinject singleton; resolve các service/use case/coordinator. | `DIContainer.shared.resolve(SomeProtocol.self)` khi cần dependency. |
| **DIAssembler.swift** | Gọi `assemble(container:)` cho tất cả Assembly (Core, Network, Storage, UIFoundation, Feature, Auth, User, Infrastructure). | Chỉ gọi từ AppBootstrapper; không gọi trực tiếp từ feature. |
| **Assemblies/CoreAssembly.swift** | Đăng ký Logger, PerformanceMonitor, ErrorMapper, KeychainManager, TokenStore, v.v. | Thêm đăng ký Core utility mới vào đây. |
| **Assemblies/NetworkAssembly.swift** | Đăng ký APIClientProtocol, interceptors (Logging, Auth, MockServer, Retry), ResponseDecoder, NetworkMonitorProtocol. | Thêm interceptor hoặc thay đổi thứ tự interceptors tại đây. |
| **Assemblies/StorageAssembly.swift** | Đăng ký LocalDatabaseProtocol (ví dụ InMemoryDatabase), CacheProtocol (LayeredCache/MemoryCache/DiskCache). | Đổi implementation database/cache khi chuyển môi trường hoặc thêm persistence. |
| **Assemblies/UIFoundationAssembly.swift** | Đăng ký ThemeManager, DeepLink handler, các service UI dùng chung. | Đăng ký service UI toàn app (theme, deep link) tại đây. |
| **Assemblies/InfrastructureAssembly.swift** | Đăng ký PendingSyncQueueProtocol, SyncManagerProtocol, BackgroundTaskManager, DeviceTokenStore, PushNotificationService. | Cấu hình sync, background, push; feature gọi `whenOnline(perform:)` qua SyncManager resolve từ đây. |

---

## 2. Core

Các thành phần nền: network, storage, security, logging, error, performance, sync, push, background.

### 2.1 Core/Network

**Base**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **APIClient.swift** | Protocol + implementation: build request từ Endpoint, chạy interceptors, gọi URLSession, decode response. | Feature không gọi trực tiếp; dùng qua Repository/RemoteDataSource nhận APIClientProtocol từ DI. |
| **Endpoint.swift** | Định nghĩa cấu trúc endpoint (path, method, query, body, headers). | Mỗi feature có Endpoint riêng (AuthEndpoint, UserEndpoint, FeatureEndpoint); build `URLRequest` qua RequestBuilder. |
| **RequestBuilder.swift** | Chuyển Endpoint + baseURL thành URLRequest (URL, method, body, headers). | APIClient dùng nội bộ; test có thể kiểm tra request build đúng. |
| **ResponseDecoder.swift** | Decode Data → Decodable; xử lý JSON, error body. | APIClient inject decoder; có thể thay bằng custom decoder nếu API khác format. |

**Error**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **NetworkError.swift** | Định nghĩa lỗi network (invalidURL, noData, statusCode, decoding, v.v.). | Throw từ APIClient/Repository; map sang AppError hoặc FeatureError trong UseCase. |
| **HTTPStatusCode.swift** | Hằng số HTTP (200, 401, 404, 500, v.v.). | Dùng khi kiểm tra `response.statusCode` trong interceptor hoặc error mapping. |

**Interceptors**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Interceptor.swift** | Protocol: `adapt(_ request:)` trả về URLRequest (async). | Mọi interceptor implement protocol này; thứ tự trong mảng quyết định thứ tự chạy. |
| **AuthInterceptor.swift** | Thêm header `Authorization: Bearer <accessToken>`; nếu response 401 thì gọi TokenStore.clearTokens(). | Đăng ký trong NetworkAssembly; cần TokenStore và Logger. |
| **LoggingInterceptor.swift** | Log request (URL, method) và response (status). | Đăng ký để debug; có thể tắt trong production qua Logger level. |
| **MockServerInterceptor.swift** | Trả response từ MockResponseProvider khi AppEnvironment == .mock. | Đăng ký trong NetworkAssembly khi dùng mock; không dùng khi gọi API thật. |
| **RetryInterceptor.swift** | Retry request khi gặp lỗi tạm thời (theo chính sách). | Tùy chọn; đăng ký sau Auth/Logging nếu cần retry. |

**NetworkMonitor**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **NetworkMonitorProtocol.swift** | Protocol: `isConnected: Bool`. | SyncManager, Repository có thể kiểm tra mạng trước khi gọi API. |
| **DefaultNetworkMonitor.swift** | Implementation: dùng NWPathMonitor (hoặc tương đương) để cập nhật isConnected. | Đăng ký trong NetworkAssembly; resolve NetworkMonitorProtocol. |

### 2.2 Core/Storage

**Abstraction**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **LocalDatabaseProtocol.swift** | Protocol CRUD + fetch cho Storable; có performTransaction. | Repository/DataSource dùng để persist record (FeatureRecord, v.v.). |
| **Storable** | Protocol trong cùng file: primaryKey. | Model local (class) conform để dùng với LocalDatabaseProtocol. |
| **DatabaseConfiguration.swift** | Cấu hình database (path, schema version). | Adapter (Realm, CoreData, SQLite) đọc config từ đây. |
| **QueryProtocol.swift** | Định nghĩa query/predicate/sort (nếu dùng abstraction query). | Tùy adapter có dùng hay không. |
| **MigrationProtocol.swift** | Protocol migration giữa các schema version. | Adapter gọi khi mở database để chạy migration. |

**Cache**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **CacheProtocol.swift** | set/get (Encodable/Decodable), remove, removeAll, exists. | UseCase (ví dụ FetchFeatureUseCase) dùng để cache list; key do feature định nghĩa. |
| **MemoryCache.swift** | Cache trong memory (LRU hoặc dictionary); thread-safe. | L1 của LayeredCache; đăng ký trong StorageAssembly. |
| **DiskCache.swift** | Cache trên disk (file); Codable. | L2 của LayeredCache. |
| **LayeredCache.swift** | Đọc memory trước, không có thì đọc disk; ghi cả hai. | Đăng ký làm CacheProtocol khi cần cache persist giữa session. |

**Adapters**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **InMemory/InMemoryDatabase.swift** | Implementation LocalDatabaseProtocol lưu trong RAM. | Dùng cho test hoặc khi chưa cần persist; đăng ký trong StorageAssembly. |
| **Realm/RealmDatabase.swift** | Adapter Realm cho LocalDatabaseProtocol. | Khi cần persist thật; cần RealmSwift package. |
| **Realm/RealmMigration.swift** | Migration schema Realm. | Gắn với RealmDatabase. |
| **CoreData/**, **SQLite/** | Tương tự: adapter + migration. | Dùng khi chọn stack CoreData/SQLite. |

### 2.3 Core/Security

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **TokenStore.swift** | Protocol + implementation: lưu/xóa access & refresh token (Keychain); isAuthenticated. | Auth flow gọi setTokens/clearTokens; AuthInterceptor đọc token và clear khi 401. |
| **KeychainManager.swift** | Đọc/ghi Keychain (generic Data); dùng cho TokenStore, DeviceTokenStore. | TokenStore và các store nhạy cảm dùng; không lưu plain text nhạy cảm ngoài Keychain. |
| **SecureStorageProtocol.swift** | Abstraction lưu trữ an toàn. | Có thể wrap KeychainManager. |
| **CryptoProvider.swift** | Mã hóa/giải mã (nếu cần). | Dùng khi cần encrypt payload trước khi lưu. |
| **DatabaseEncryptionProvider.swift** | Cung cấp key/option encrypt database. | Tùy adapter hỗ trợ encryption. |

### 2.4 Core/Logging

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Logger.swift** | Singleton: info, error, warning, debug; gửi đến các destination. | Dùng `Logger.shared.info("...")` trong UseCase, ViewModel, Repository; không log data nhạy cảm. |
| **LogDestination.swift** | Protocol destination (console, file, remote). | ConsoleDestination, FileDestination implement. |
| **LogFormatter.swift** | Format nội dung log (timestamp, level, message). | Logger dùng khi gửi đến destination. |
| **LogLevel.swift** | Enum level (debug, info, warning, error). | Filter log theo môi trường. |
| **Destinations/ConsoleDestination.swift** | In log ra console. | Đăng ký trong CoreAssembly/Logger config. |

### 2.5 Core/ErrorHandling

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **AppError.swift** | Định nghĩa lỗi toàn app (network, auth, validation, unknown). | ErrorMapper map NSError/FeatureError/AuthError → AppError; UI hiển thị từ AppError. |
| **ErrorMapper.swift** | Map Error → AppError (domain, code, message). | Dùng ở boundary (ViewModel, Coordinator) khi cần hiển thị lỗi thống nhất. |
| **ErrorPresenter.swift** | Trình bày lỗi lên UI (alert, banner). | ViewModel/ViewController gọi khi có error để hiển thị. |
| **ErrorRecoveryStrategy.swift** | Chiến lược retry/fallback (nếu có). | Tùy chọn khi cần flow phục hồi. |

### 2.6 Core/Concurrency

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **TaskCoordinator.swift** | Quản lý Task theo id: execute(id:priority:operation:), cancel(id:), cancelAll. | Dùng khi cần hủy/hạn chế task theo id (ví dụ search debounce). |
| **AsyncOperation.swift** | Operation async (nếu dùng OperationQueue). | Tùy chọn thay cho Task. |
| **CancellationManager.swift** | Hỗ trợ hủy nhiều work. | Dùng khi cần cancel nhiều tác vụ cùng lúc. |

### 2.7 Core/Sync

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **PendingSyncQueueProtocol.swift** | Protocol: enqueue, dequeue(limit:), remove(ids:), count, removeAll. | Repository đẩy item pending lên queue khi offline. |
| **PendingSyncItem.swift** | Model: id, kind (create/update/delete), entityType, payload, createdAt. | Item lưu trong queue; payload là Data (encoded entity). |
| **UserDefaultsPendingSyncQueue.swift** | Implementation queue lưu bằng UserDefaults. | Đăng ký trong InfrastructureAssembly; production có thể đổi sang Core Data/file. |
| **SyncManager.swift** | whenOnline(perform:); triggerSync(); performSync() async. | Feature/App đăng ký closure sync trong whenOnline; SceneDelegate gọi triggerSync khi foreground. |

### 2.8 Core/Background

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **BackgroundTaskManager.swift** | Schedule BGAppRefreshTask; handler gọi SyncManager.performSync() rồi setTaskCompleted. | AppBootstrapper/SceneDelegate gọi schedule khi vào background. |

### 2.9 Core/Push

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **DeviceTokenStore.swift** | Lưu device token (Keychain). | PushNotificationService gọi sau khi nhận token từ system. |
| **PushNotificationService.swift** | Request authorization, registerForRemoteNotifications; nhận token và lưu qua DeviceTokenStore. | AppDelegate chuyển token vào service; có thể gửi token lên backend. |

### 2.10 Core/Performance

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **PerformanceMonitor.swift** | Đo thời gian section (start/end); có thể log. | Dùng khi profile performance (API, render). |
| **MemoryTracker.swift** | Theo dõi memory (nếu cần). | Tùy chọn. |
| **NetworkPerformanceTracker.swift** | Theo dõi latency/throughput network. | Tùy chọn. |

### 2.11 Core/Mock

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **MockServer/MockServerManager.swift** | Quản lý mock server (start/stop, port). | Khi AppEnvironment == .mock. |
| **MockServer/MockResponseProvider.swift** | Cung cấp response theo request (path, method). | MockServerInterceptor gọi để trả body/status. |
| **MockServer/MockServerEnvironment.swift** | Cấu hình URL/port mock. | MockServerManager dùng. |
| **Fixtures/*.json** | Response mẫu (error, user). | MockResponseProvider load khi cần. |

### 2.12 Core/Utils

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Extensions/Array+Extensions.swift** | Extension Array (safe subscript, v.v.). | Dùng chung toàn project. |
| **Extensions/Date+Extensions.swift** | Format, ISO8601, so sánh. | Mapper, Entity dùng. |
| **Extensions/String+Extensions.swift** | Validation, trim, encoding. | Validation input. |
| **Extensions/DispatchQueue+Extensions.swift** | Main async, delay. | Đảm bảo cập nhật UI trên main. |
| **Helpers/ValidationHelper.swift** | Hàm validate email, length, v.v. | ViewModel, UseCase. |
| **Helpers/ThreadSafetyHelper.swift** | Lock, thread-safe access. | Khi cần đồng bộ trong Core. |
| **Protocols/Identifiable.swift** | Protocol id (nếu không dùng Swift Identifiable). | Tùy project. |
| **Protocols/Mappable.swift** | Protocol map DTO ↔ Entity. | Có thể dùng cho Mapper. |

---

## 3. Features

Mỗi feature có cấu trúc: **Domain** (Entities, UseCases, RepositoryProtocol), **Data** (DTOs, Mappers, Repositories, DataSources), **Presentation** (View, ViewModel, Coordinator), **DI** (Assembly).

### 3.1 Features/_Template

Template tham chiếu cho feature mới (CRUD list, cache, offline).

**Domain**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Entities/FeatureEntity.swift** | Model nghiệp vụ: id, title, description, status, priority, tags; validate(); isActive, displayTitle. | UseCase và ViewModel làm việc với Entity. |
| **Entities/FeatureError.swift** | Lỗi feature: validation, notFound, network, unknown; from(error). | UseCase/Repository throw FeatureError; map từ NetworkError nếu cần. |
| **Repositories/FeatureRepositoryProtocol.swift** | Protocol: fetchAll, fetch(id:), create, update, delete, deleteAll, search. | UseCase chỉ phụ thuộc protocol. |
| **UseCases/FetchFeatureUseCase.swift** | Đọc cache trước; không có thì gọi repository, validate, lọc active, sort priority, cache lại. execute(id:) fetch một. | ViewModel gọi execute() / execute(id:). |
| **UseCases/CreateFeatureUseCase.swift** | Gọi repository.create(entity). | ViewModel create screen. |
| **UseCases/UpdateFeatureUseCase.swift** | Gọi repository.update(entity). | ViewModel edit screen. |
| **UseCases/DeleteFeatureUseCase.swift** | Gọi repository.delete(id:). | ViewModel list/ detail delete. |

**Data**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **DTOs/FeatureDTO.swift** | FeatureDTO (API response), FeatureRequestDTO (create/update); CodingKeys. | RemoteDataSource trả DTO; Mapper map DTO ↔ Entity. |
| **Mappers/FeatureDTOMapper.swift** | toDomain(DTO), toDomain([DTO]), toRequestDTO(Entity); parse date, status; throw MappingError. | Repository gọi mapper sau khi nhận DTO từ DataSource. |
| **DataSources/Remote/FeatureEndpoint.swift** | Định nghĩa endpoint list, get, create, update, delete. | FeatureRemoteDataSource build Endpoint và gọi APIClient. |
| **DataSources/Remote/FeatureRemoteDataSource.swift** | Gọi APIClient với FeatureEndpoint; trả DTO. | FeatureRepository gọi khi cần data từ API. |
| **DataSources/Local/FeatureLocalDataSource.swift** | Fetch/create/update/delete FeatureRecord qua LocalDatabaseProtocol; map Record ↔ Entity. | Repository dùng khi offline-first hoặc cache local. |
| **DataSources/Local/FeatureRecord.swift** | Storable class: id, title, featureDescription, dates, statusRaw, priority, tags; from(entity), toEntity(). | LocalDataSource dùng với database.fetch/create/update/delete. |
| **Repositories/FeatureRepository.swift** | Implement FeatureRepositoryProtocol: ưu tiên remote (hoặc local), map DTO/Record qua Mapper. | Đăng ký trong FeatureAssembly; UseCase nhận protocol. |

**Presentation**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **ViewModel/FeatureViewModel.swift** | State (idle/loading/loaded/empty/error); fetchData, refresh, numberOfItems, item(at:), didSelectItem, didTapCreate, didTapDelete; gọi UseCase và Coordinator. | ViewController bind state và gọi action từ ViewModel. |
| **ViewModel/FeatureViewModelProtocol.swift** | Protocol cho ViewModel (để test/dependency). | Coordinator/VC có thể phụ thuộc protocol. |
| **ViewModel/FeatureViewState.swift** | Enum state: idle, loading, loaded([Entity]), empty, error(Error). | ViewModel publish state; View hiển thị theo state. |
| **View/FeatureViewController.swift** | TableView, bind ViewModel (state, items); gọi viewDidLoad → fetchData; tap cell → didSelectItem; pull refresh, create button, delete. | Tab Home dùng coordinator đẩy màn này. |
| **View/Subviews/FeatureTableViewCell.swift** | Cell hiển thị title, subtitle (description), priority. | FeatureViewController register và dequeue. |
| **Coordinator/FeatureCoordinator.swift** | start() đẩy FeatureViewController; showDetail(for:), showCreateScreen(), showEdit(for:). | TabBarCoordinator giữ FeatureCoordinator cho tab Home. |
| **Coordinator/FeatureCoordinatorProtocol.swift** | Protocol coordinator cho ViewModel gọi. | ViewModel inject protocol để navigate. |

**DI**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **FeatureAssembly.swift** | Đăng ký FeatureRepositoryProtocol, Fetch/Create/Update/Delete UseCase, FeatureCoordinator, ViewModel (nếu cần); resolve dependencies từ container. | DIAssembler đã gồm FeatureAssembly; tab Home resolve FeatureCoordinator. |

### 3.2 Features/Auth

Đăng nhập / đăng xuất; lưu token qua TokenStore.

**Domain**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Entities/AuthSession.swift** | accessToken, refreshToken?, expiresIn?. | Repository.login trả AuthSession; LoginUseCase lưu qua TokenStore. |
| **Entities/AuthError.swift** | invalidCredentials, invalidInput, serverError, networkError, unknown; from(error). | RemoteDataSource/UseCase throw AuthError. |
| **Repositories/AuthRepositoryProtocol.swift** | login(email:password:), logout(). | LoginUseCase, LogoutUseCase gọi. |
| **UseCases/LoginUseCase.swift** | Trim email/password; validate rỗng → invalidInput; gọi repository.login; tokenStore.setTokens(session). | LoginViewModel gọi execute(email:password:). |
| **UseCases/LogoutUseCase.swift** | tokenStore.clearTokens(); repository.logout(). | Profile hoặc menu logout. |

**Data**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **DTOs/AuthDTO.swift** | LoginRequestDTO, LoginResponseDTO (access_token, refresh_token, expires_in). | AuthRemoteDataSource trả LoginResponseDTO. |
| **Mappers/AuthDTOMapper.swift** | toSession(LoginResponseDTO) → AuthSession. | AuthRepository gọi sau khi có DTO. |
| **DataSources/Remote/AuthEndpoint.swift** | Endpoint login (POST body email/password), logout. | AuthRemoteDataSource dùng. |
| **DataSources/Remote/AuthRemoteDataSource.swift** | login/logout qua APIClient; khi mock trả mock token; 401 → invalidCredentials. | AuthRepository inject và gọi. |
| **Repositories/AuthRepository.swift** | login → remote.login → AuthDTOMapper.toSession; logout → remote.logout. | Đăng ký trong AuthAssembly. |

**Presentation**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **ViewModel/LoginViewModel.swift** | Email, password; submit → LoginUseCase.execute; loading/success/error; onLoginSuccess callback. | LoginViewController bind field và nút; success thì gọi onLoginSuccess. |
| **ViewModel/LoginViewModelProtocol.swift** | Protocol ViewModel. | AuthCoordinator có thể inject protocol. |
| **ViewModel/AuthViewState.swift** | Enum: idle, loading, success, error. | LoginViewModel publish. |
| **View/LoginViewController.swift** | Form email/password, nút login; gọi ViewModel.submit. | AuthCoordinator đẩy khi chưa đăng nhập. |
| **Coordinator/AuthCoordinator.swift** | start() → LoginViewController; onLoginSuccess → callback (AppCoordinator showMainFlow). | AppCoordinator tạo và start khi !isUserAuthenticated. |
| **Coordinator/AuthCoordinatorProtocol.swift** | Protocol cho AuthCoordinator. | AppCoordinator phụ thuộc protocol. |

**DI**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **AuthAssembly.swift** | Đăng ký AuthRepositoryProtocol, AuthRemoteDataSource, LoginUseCase, LogoutUseCase, AuthCoordinator, LoginViewModel. | DIAssembler đã gồm AuthAssembly. |

### 3.3 Features/User

Thông tin user hiện tại (profile); dùng token từ TokenStore cho API /me.

**Domain**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Entities/UserEntity.swift** | id, email, name, avatarURL; displayName. | GetCurrentUserUseCase trả UserEntity. |
| **Entities/UserError.swift** | notFound, serverError, networkError, unknown; from(error). | UserRepository throw. |
| **Repositories/UserRepositoryProtocol.swift** | getCurrentUser(). | GetCurrentUserUseCase gọi. |
| **UseCases/GetCurrentUserUseCase.swift** | repository.getCurrentUser(). | ProfileViewModel load user. |

**Data**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **DTOs/UserDTO.swift** | DTO từ API /me (id, email, name, avatar_url). | UserRemoteDataSource trả DTO. |
| **Mappers/UserDTOMapper.swift** | toEntity(DTO) → UserEntity. | UserRepository gọi. |
| **DataSources/Remote/UserEndpoint.swift** | Endpoint GET /me. | UserRemoteDataSource dùng. |
| **DataSources/Remote/UserRemoteDataSource.swift** | Gọi APIClient với UserEndpoint; khi mock trả user mẫu. | UserRepository inject. |
| **Repositories/UserRepository.swift** | getCurrentUser → remote + mapper. | Đăng ký trong UserAssembly. |

**Presentation**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **ViewModel/ProfileViewModel.swift** | Load user qua GetCurrentUserUseCase; state (loading/loaded/error); logout qua LogoutUseCase. | ProfileViewController bind avatar, name, email; nút logout. |
| **ViewModel/ProfileViewState.swift** | Enum state profile. | ProfileViewModel publish. |
| **View/ProfileViewController.swift** | Hiển thị user (name, email), nút logout; gọi ViewModel load và logout. | Tab Profile dùng màn này. |

**DI**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **UserAssembly.swift** | Đăng ký UserRepositoryProtocol, UserRemoteDataSource, GetCurrentUserUseCase. | TabBarCoordinator resolve GetCurrentUserUseCase cho Profile. |

---

## 4. UIFoundation

Design system, navigation, base UI (UIKit + SwiftUI), accessibility.

### 4.1 UIFoundation/DesignSystem

**Tokens**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Tokens/Colors.swift** | Màu chính (primary, background, text, error); Light/Dark. | View dùng DesignSystemColors.primary.uiColor, .textPrimary, v.v. |
| **Tokens/Typography.swift** | Font (title1–caption2). | DesignSystemTypography.title3.font. |
| **Tokens/Spacing.swift** | Khoảng cách (xs, sm, md, lg). | DesignSystemSpacing.md. |
| **Tokens/CornerRadius.swift** | Bo góc (sm, md, lg). | DesignSystemCornerRadius.md. |
| **Tokens/Shadows.swift** | Bóng (nếu có). | Card, modal. |
| **Tokens/BorderWidth.swift** | Độ dày viền. | DesignSystemBorderWidth. |

**Theme**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Theme/Theme.swift** | Protocol Theme; LightTheme, DarkTheme. | ThemeManager.current apply lên view. |
| **Theme/ThemeManager.swift** | current theme; set theme; notify observer. | ViewController/View subscribe để cập nhật khi đổi theme. |

**Icons**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Icons/IconSet.swift** | Tên SF Symbol (Content.empty, Status.error, v.v.). | Image(systemName: IconSet.Content.empty). |

### 4.2 UIFoundation/Navigation

**Coordinator**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Coordinator/Coordinator.swift** | Protocol Coordinator (navigationController, childCoordinators, start, finish, addChild, removeChild); extension; BaseCoordinator. | Mọi coordinator kế thừa BaseCoordinator. |
| **Coordinator/AppCoordinator.swift** | Root: isUserAuthenticated → showAuthFlow / showMainFlow; window.rootViewController; resolve AuthCoordinator, TabBarCoordinator. | SceneDelegate gọi start() sau khi có window. |
| **Coordinator/NavigationCoordinator.swift** | Base có Router; start() fatalError (subclass override). | Coordinator cần push/present dùng Router. |
| **Coordinator/TabBarCoordinator.swift** | Tab bar (Home, Search, Profile); resolve FeatureCoordinator, GetCurrentUserUseCase; onLogout callback. | AppCoordinator showMainFlow() đẩy TabBarCoordinator. |

**Router**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Router/Router.swift** | Protocol: push, pop, present, dismiss. | NavigationCoordinator dùng để điều hướng. |
| **Router/NavigationRouter.swift** | Implementation với UINavigationController. | Inject vào NavigationCoordinator. |

**DeepLink**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **DeepLink/DeepLinkRoute.swift** | Enum route (home, feature(id:), profile, v.v.). | Parser trả route. |
| **DeepLink/DeepLinkParser.swift** | Parse URL → DeepLinkRoute. | Handler gọi parser rồi route. |
| **DeepLink/DeepLinkHandler.swift** | Nhận URL; parse; gửi đến AppCoordinator/Coordinator tương ứng. | AppDelegate/SceneDelegate gọi khi mở link. |
| **DeepLink/UniversalLinkManager.swift** | Cấu hình associated domains (nếu có). | Tùy project. |

**Transition**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Transition/TransitionAnimator.swift** | Custom transition animation. | Khi present/push custom. |
| **Transition/CustomTransitions.swift** | Định nghĩa transition cụ thể. | Gắn với animator. |

**Khác**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **PlaceholderViewController.swift** | Màn placeholder (tab chưa có màn thật). | Tab bar dùng cho tab chưa implement. |

### 4.3 UIFoundation/UIKit

**Base**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Base/BaseViewController.swift** | setupUI, setupConstraints, setupBindings, applyTheme; onViewDidLoad, loadingContainerView. | ViewController kế thừa; override setup* và bind ViewModel. |
| **Base/BaseView.swift** | UIView programmatic; setupView(), setupConstraints(). | EmptyStateView, CardView kế thừa. |
| **Base/BaseNavigationController.swift** | NavigationController với style/theme. | AppCoordinator dùng làm root. |
| **Base/BaseTableViewCell.swift** | setupCell(), configure(with:), onReuse(). | Cell list kế thừa. |
| **Base/BaseCollectionViewCell.swift** | Tương tự cho collection. | Cell grid. |

**Components**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Buttons/PrimaryButton.swift** | Nút chính (filled). | Login, submit. |
| **Buttons/SecondaryButton.swift** | Nút phụ (outline). | Cancel, secondary action. |
| **Buttons/TextButton.swift** | Nút text. | Link-style. |
| **Cards/CardView.swift** | Container card (background, corner radius). | List item, detail block. |
| **Cards/ShadowCardView.swift** | Card có shadow. | Subclass CardView. |
| **EmptyStates/EmptyStateView.swift** | Hình, title, message, nút action. | List trống, empty search. |
| **EmptyStates/ErrorStateView.swift** | Empty state lỗi + Retry. | Subclass EmptyStateView. |
| **Labels/TitleLabel.swift** | Label tiêu đề. | Design system font/color. |
| **Labels/BodyLabel.swift** | Label nội dung. | |
| **Labels/CaptionLabel.swift** | Label chú thích. | |
| **TextFields/StandardTextField.swift** | TextField + validation state, error label. | Form input. |
| **TextFields/SecureTextField.swift** | Subclass cho password. | |
| **TextFields/SearchTextField.swift** | Subclass cho search. | |
| **LoadingViews/ActivityIndicator.swift** | Spinner. | Full screen hoặc inline. |
| **LoadingViews/SkeletonView.swift** | Skeleton loading. | List placeholder. |
| **LoadingViews/ShimmerView.swift** | Shimmer effect. | |

### 4.4 UIFoundation/SwiftUI

**Base**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Base/SwiftUIBaseView.swift** | View wrapper: content + loading overlay + error overlay + retry. | Màn SwiftUI dùng làm root. |
| **Base/BaseViewModel.swift** | ObservableObject base. | ViewModel SwiftUI kế thừa. |
| **Base/ViewState.swift** | Enum state chung (loading, loaded, error). | Tùy view. |

**Components**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **SwiftUIEmptyStateView.swift** | Empty state (icon, title, message, button). | ErrorView dùng. |
| **ErrorView.swift** | SwiftUI error + retry; bên trong SwiftUIEmptyStateView. | Màn SwiftUI hiển thị lỗi. |
| **LoadingView.swift** | ProgressView hoặc skeleton. | |
| **Buttons/SwiftUIPrimaryButton.swift** | Nút chính SwiftUI. | Form SwiftUI. |
| **Buttons/SwiftUISecondaryButton.swift** | Nút phụ SwiftUI. | |

**Modifiers**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **LoadingModifier.swift** | .loading(isLoading). | Overlay loading lên view. |
| **ShimmerModifier.swift** | .shimmer(). | Skeleton SwiftUI. |
| **CardModifier.swift** | .card(). | Style card. |

**Extensions**

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **View+Extensions.swift** | Extension View (padding, color từ design system). | Dùng trong SwiftUI view. |
| **Binding+Extensions.swift** | Extension Binding. | Two-way binding helper. |

### 4.5 UIFoundation/Accessibility

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **AccessibilityIdentifiers.swift** | Hằng số accessibilityIdentifier. | UI test và VoiceOver. |
| **AccessibilityExtensions.swift** | Extension set label, hint, trait. | Gán cho control. |
| **DynamicTypeSupport.swift** | Hỗ trợ font động. | Label, TextField. |
| **VoiceOverHelper.swift** | Announce, focus. | Trải nghiệm VoiceOver. |

---

## 5. Resources

| Thư mục / File | Trách nhiệm | Cách dùng |
|----------------|-------------|-----------|
| **Assets.xcassets** | App icon, image set. | AppIcon.appiconset bắt buộc; thêm image set khi cần. |
| **Localization/en.lproj, vi.lproj** | Localizable.strings. | SwiftGen strings → Strings+Generated. |
| **SwiftGen/swiftgen.yml** | Cấu hình SwiftGen (strings, xcassets). | Chạy Scripts/BuildScripts/run_swiftgen.sh. |
| **SwiftGen/Generated/Assets+Generated.swift** | Enum Asset (Images, Colors). | Dùng Asset.Images.xxx. |
| **SwiftGen/Generated/Strings+Generated.swift** | Generated strings. | Dùng L10n.xxx. |

---

## 6. Config

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Shared.xcconfig** | Cấu chung (DEPLOYMENT_TARGET, v.v.). | Base cho Debug/Release. |
| **Dev.xcconfig** | Debug: API_BASE_URL, ENABLE_LOGGING, ENABLE_MOCK_SERVER. | Scheme Debug dùng. |
| **Staging.xcconfig** | Staging URL, flags. | Scheme Staging. |
| **Production.xcconfig** | Production URL, tắt mock. | Scheme Release. |

---

## 7. CI

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **Fastlane/Fastfile** | Lanes: test, lint, build, ci. | CI chạy `fastlane ci` hoặc từng lane. |
| **Fastlane/Matchfile** | Template code signing (Match). | Tùy team. |
| **Scripts/test.sh** | Chạy xcodebuild test. | GitHub Actions, local. |
| **Scripts/lint.sh** | SwiftLint. | PR check. |
| **.github/workflows/ci.yml** | Build, test, lint trên push/PR. | Tự chạy. |
| **.github/workflows/release.yml** | Build release, trigger tag. | Release flow. |

---

## 8. Scripts

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **BuildScripts/run_swiftgen.sh** | Chạy SwiftGen (strings, assets). | Sau khi sửa Localization/Assets. |
| **BuildScripts/run_tests.sh** | Chạy unit test. | Local, CI. |
| **SwiftLint/.swiftlint.yml** | Cấu hình SwiftLint. | lint.sh đọc. |
| **SwiftFormat/.swiftformat** | Cấu hình SwiftFormat. | Format code. |

---

## 9. Tests

| Thư mục / File | Trách nhiệm | Cách dùng |
|----------------|-------------|-----------|
| **UnitTests/Core/** | Test ErrorMapper, APIClient, RequestBuilder, KeychainManager, InMemoryDatabase. | Kiểm tra Core đúng contract. |
| **UnitTests/Features/** | FeatureDTOMapper, FetchFeatureUseCase, FeatureViewModel; Mocks (FeatureMocks). | Test template feature. |
| **UnitTests/Auth/** | LoginUseCase, AuthRepository; AuthMocks. | Test auth flow. |
| **UnitTests/User/** | GetCurrentUserUseCase; UserMocks. | Test user profile. |
| **UnitTests/Sync/** | SyncManager, PendingSyncQueue (UserDefaults); SyncMocks. | Test sync và queue. |
| **TestUtilities/** | XCTestCase+Async, helper. | Dùng trong test. |

---

## 10. Docs

| File | Trách nhiệm | Cách dùng |
|------|-------------|-----------|
| **ProjectStructure.md** | Hướng dẫn cấu trúc dự án. | Tham khảo khi tìm hiểu folder structure. |
| **BackendIntegrationGuide.md** | Hướng dẫn tích hợp Backend và Database Schema. | Cho Backend Developer/Agent. |
| **FeatureGenerationPrompt.md** | Template tạo feature mới. | Dùng với Agent. |

---

## Ghi chú sử dụng

- **Thêm feature mới:** Copy `Features/_Template`, đổi tên Feature → TênMới; cập nhật Domain/Data/Presentation/DI; đăng ký Assembly trong DIAssembler; gắn Coordinator vào Tab hoặc AppCoordinator.
- **Thêm endpoint:** Trong feature, thêm case vào Endpoint và gọi từ RemoteDataSource; Repository gọi DataSource.
- **Đổi cache/database:** Sửa StorageAssembly / InfrastructureAssembly; đổi implementation, không đổi protocol (trừ khi mở rộng contract).
- **Chạy test:** `xcodebuild test -scheme BaseIOSApp -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BaseIOSAppTests` hoặc `./CI/Scripts/test.sh`.

Nếu cần chi tiết thêm cho một folder hoặc file cụ thể, có thể mở rộng từng section tương ứng trong tài liệu này.
