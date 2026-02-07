# BaseIOSApp – Test Plan

> Kế hoạch kiểm thử: test cases hiện có và các trường hợp cần bổ sung.

**Cập nhật:** 2026-02-07

---

## 1. Kết quả chạy test hiện tại

- **Lệnh:** `xcodebuild test -scheme BaseIOSApp -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BaseIOSAppTests`
- **Kết quả:** **45 tests passed**, 0 failures.
- **Thời gian:** ~0.5–1s (tùy máy).

### 1.1 Test cases đã có (theo nhóm)

| Nhóm | File test | Số test | Nội dung chính |
|------|-----------|---------|----------------|
| **Core – ErrorHandling** | ErrorMapperTests | 1+ | Map error → AppError |
| **Core – Network** | APIClientTests, RequestBuilderTests | 1+ | Build request, query params |
| **Core – Security** | KeychainManagerTests | 1 | Save/load Keychain |
| **Core – Storage** | InMemoryDatabaseTests | 1 | Create + fetch InMemory |
| **Features – Feature** | FeatureDTOMapperTests | 5 | Mapper: toDomain, toRequestDTO, invalid date/status |
| **Features – Feature** | FetchFeatureUseCaseTests | 6 | Cache hit/miss, filter/sort, repository throw, execute(id:) |
| **Features – Feature** | FeatureViewModelTests | 7 | viewDidLoad, numberOfItems, item(at:), didSelectItem, didTapCreate, refresh, didTapDelete |
| **Auth** | LoginUseCaseTests | 6 | Success, trim, empty/whitespace → invalidInput, repository throw |
| **Auth** | AuthRepositoryTests | 4 | login DTO→Session, logout call remote |
| **User** | GetCurrentUserUseCaseTests | 2 | execute returns user, repository throw |
| **Sync** | SyncManagerTests | 5 | whenOnline, triggerSync offline, performSync online/offline, closure throw |
| **Sync** | PendingSyncQueueTests | 5 | enqueue, count, dequeue order/limit, remove(ids:), removeAll |

---

## 2. Test plan mới – Các trường hợp chưa có / nên bổ sung

### 2.1 Core

| Thành phần | Trường hợp đề xuất | Mục đích |
|------------|--------------------|----------|
| **APIClient** | Decode success, decode failure, network error, timeout | Đảm bảo xử lý response và lỗi đúng |
| **ResponseDecoder** | JSON valid → model, JSON invalid → error | Kiểm tra decode và error handling |
| **Endpoint** | URL, method, headers, body đúng với từng case | Đảm bảo request build đúng |
| **AuthInterceptor** | Request có Bearer token khi có accessToken; 401 → clear token | Đảm bảo auth header và xử lý 401 |
| **LoggingInterceptor** | Request/response được log (có thể mock Logger) | Đảm bảo không crash, log được gọi |
| **CacheProtocol / MemoryCache** | set → get cùng key trả đúng; expiration; remove | Đảm bảo cache hoạt động đúng |
| **LayeredCache** | set → get từ memory; set → get từ disk khi memory trống | Đảm bảo L1/L2 và thứ tự đọc |
| **TokenStore** (mock Keychain) | setTokens → accessToken/refreshToken/isAuthenticated; clearTokens | Đảm bảo lưu/xóa token đúng |
| **ErrorMapper** | NSError domain/code → AppError tương ứng | Bổ sung case bên cạnh test hiện có |
| **ErrorPresenter** | present(error:) gọi callback / alert (nếu có interface rõ) | Kiểm tra flow trình bày lỗi |
| **Logger** | Các level (info, error, warning) gọi đúng destination | Có thể test với MockDestination |
| **PerformanceMonitor** | start/end section, không crash | Smoke test |
| **BackgroundTaskManager** | schedule/expiration handler được gọi (mock BGTaskScheduler nếu cần) | Tùy độ phức tạp mock |
| **PushNotificationService** | register, save token (mock) | Tùy mức độ cần test push |
| **DeviceTokenStore** | Save/load device token (mock Keychain) | Giống TokenStore |

### 2.2 Features

| Thành phần | Trường hợp đề xuất | Mục đích |
|------------|--------------------|----------|
| **LogoutUseCase** | execute() gọi repository.logout + tokenStore.clearTokens | Đảm bảo logout flow đúng |
| **CreateFeatureUseCase** | execute(entity) gọi repository, trả entity hoặc throw | Đồng bộ với template CRUD |
| **UpdateFeatureUseCase** | execute(entity) gọi repository, trả entity hoặc throw | Đồng bộ với template CRUD |
| **DeleteFeatureUseCase** | execute(id) gọi repository.delete | Đồng bảo với ViewModel delete |
| **FeatureRepository** | fetchAll từ remote/local, map DTO → Entity; fetch(id:) | Integration-style với mock data source |
| **FeatureLocalDataSource** | fetchAll, read(id:), create, update, delete (với InMemoryDatabase) | Đảm bảo persistence layer đúng |
| **LoginViewModel** | submit với email/password → loading → success/error; validation | Đảm bảo UI state và gọi use case đúng |
| **ProfileViewModel** | load user → state; logout | Đảm bảo GetCurrentUser + logout |
| **AuthCoordinator** | start, showLogin, onSuccess | Có thể test với mock container |
| **UserRepository** | getCurrentUser từ remote (mock data source) | Map DTO → UserEntity |

### 2.3 UIFoundation (tùy chọn)

| Thành phần | Trường hợp đề xuất | Mục đích |
|------------|--------------------|----------|
| **ThemeManager** | set theme, current theme, apply to view | Đảm bảo theme switch |
| **Design system tokens** | Colors, Typography, Spacing trả đúng value | Regression khi đổi token |
| **Router / NavigationRouter** | push, pop, present (mock UINavigationController) | Có thể test với UI test hoặc mock |
| **Coordinator (Base)** | addChild, removeChild, finish | Logic coordinator không phụ thuộc UI |

### 2.4 Integration / UI (tùy chọn)

| Loại | Mô tả |
|------|--------|
| **Flow Auth** | Chưa đăng nhập → Login → nhập đúng → vào Main; logout → về Login |
| **Flow Feature** | Vào tab Home → list (empty/loaded) → tap item → detail; create; delete |
| **Deep link** | URL → parse → route đúng coordinator/screen |
### 2.5 UI Tests (New)

| Class | Test Case | Mục đích |
|-------|-----------|----------|
| **BaseIOSAppUITests** | testLaunch | Đảm bảo app launch thành công |
| **AuthUITests** | testLoginSuccess | Kiểm tra flow login thành công và chuyển màn hình |

---

## 3. Ưu tiên thực hiện

1. **Cao:** LogoutUseCase, TokenStore (mock Keychain), AuthInterceptor (request header + 401), Cache (MemoryCache/LayeredCache), Create/Update/Delete Feature UseCases.
2. **Trung bình:** FeatureRepository với mock data source, LoginViewModel, ProfileViewModel, ErrorMapper bổ sung case.
3. **Thấp:** Logger destination, PerformanceMonitor, ThemeManager, Router, Integration/UI tests.

---

## 4. Cách chạy test

```bash
cd /Users/tomthecat/BaseIOSApp
xcodegen generate   # nếu đổi cấu trúc
xcodebuild test -scheme BaseIOSApp -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BaseIOSAppTests
```

Hoặc dùng script:

```bash
./CI/Scripts/test.sh
# hoặc
./Scripts/BuildScripts/run_tests.sh
```

---

## 5. Ghi chú

- Test hiện tại dùng **Logger.shared** hoặc mock; không dùng MockLogger cho ViewModel/UseCase vì app dùng concrete **Logger**.
- **Feature** template đã có đủ unit test cho ViewModel, FetchFeatureUseCase, Mapper; có thể mở rộng cho Create/Update/Delete UseCase và Repository.
- **Auth/User/Sync** đã có unit test cơ bản; bổ sung LogoutUseCase và TokenStore sẽ làm rõ hơn flow đăng nhập/đăng xuất.
