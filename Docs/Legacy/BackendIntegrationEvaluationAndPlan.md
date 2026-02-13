# Đánh giá, Phân tích & Kế hoạch Triển khai Backend Integration

> Dựa trên [BackendIntegrationGuide.md](./BackendIntegrationGuide.md) và codebase iOS hiện tại.

---

## 1. Đánh giá (Evaluation)

### 1.1 Điểm mạnh hiện tại

| Hạng mục | Trạng thái | Ghi chú |
|----------|------------|--------|
| **Kiến trúc** | ✅ Sẵn sàng | Clean Architecture, Network Layer (APIClient), Data flow rõ ràng |
| **Auth flow** | ✅ Có sẵn | Login, Logout, TokenStore, AuthInterceptor, LoginViewController |
| **User feature** | ✅ Có sẵn | GetCurrentUserUseCase, UserEndpoint `/users/me`, ProfileViewController |
| **TodoTracker** | ✅ Có sẵn | CRUD qua RemoteDataSource, TodoItemDTO, ViewModel |
| **Cấu hình** | ✅ Linh hoạt | AppEnvironment, BuildConfiguration, xcconfig theo môi trường |

### 1.2 Khoảng trống / Khác biệt so với API Contract

| Vấn đề | Guide (Backend) | iOS hiện tại | Hành động |
|--------|------------------|--------------|-----------|
| **Auth response** | `{ "token": "...", "user": { ... } }` | DTO: `access_token`, `refresh_token`, `expires_in` (không có `user`) | Cần thống nhất: thêm `user` vào DTO hoặc backend trả đủ field |
| **User endpoint** | `GET /me` (base `/api/v1`) → `/api/v1/me` | `GET /api/v1/users/me` | Khác path: backend dùng `/me` hay `/users/me` cần quyết định một chuẩn |
| **Todo path** | Relative to base → `/todos` | iOS dùng path `/todos` (đúng nếu base = `.../api/v1`) | ✅ Khớp nếu baseURL = `http://localhost:3000/api/v1` |
| **Register** | `POST /auth/register` | Chưa có Register trên iOS | Cần thêm: DTO, Endpoint, UseCase, UI (nếu cần) |
| **Base URL dev** | `http://localhost:3000/api/v1` | Dev.xcconfig: `https://dev-api.example.com` | Cần cấu hình local: thêm/xcconfig cho local backend |

### 1.3 Backend Quick Start (trong Guide)

- Đoạn **Quick Start** dùng **in-memory** todos, **không có Auth** (không JWT, không user_id).
- Schema **Database** (users, todos với user_id) và **API Contract** (Auth required, /me) yêu cầu backend đầy đủ hơn: DB + Auth middleware.

**Kết luận đánh giá:**  
iOS **API-Ready**; cần **điều chỉnh nhỏ** (contract path/DTO) và **bổ sung** (Register, cấu hình local). Backend cần **nâng cấp** từ mẫu in-memory lên có Auth + DB theo schema trong Guide.

---

## 2. Phân tích (Analysis)

### 2.1 Luồng dữ liệu (đã có trên iOS)

```
RemoteDataSource → Repository → UseCase → ViewModel → View
         ↑
    APIClient (baseURL + path, Interceptors: Auth, Logging, Retry)
```

- **Auth:** Token lưu Keychain (TokenStore), AuthInterceptor gắn `Authorization: Bearer <token>`.
- **TodoTracker:** Path `/todos`, `/todos/:id/toggle`, `/todos/:id` — đúng với Guide nếu base = `/api/v1`.

### 2.2 Rủi ro nếu triển khai đúng Guide

1. **Contract lệch**  
   - Backend trả `token` + `user`, iOS chỉ parse `access_token`/`refresh_token` → cần mở rộng `LoginResponseDTO` (và mapper) để nhận cả `user` hoặc bỏ `user` nếu backend không trả.
2. **Path `/me` vs `/users/me`**  
   - Một bên phải đổi: hoặc backend expose `/api/v1/me`, hoặc iOS đổi sang `/users/me` (đã có).
3. **Register**  
   - Guide có `POST /auth/register`, iOS chưa có → cần thêm từ Data → Domain → Presentation nếu product yêu cầu đăng ký.

### 2.3 Phụ thuộc (Dependencies)

- **Backend:** Node (Express) + DB (SQL) theo schema Guide; JWT cho Auth; CORS cho `localhost`.
- **iOS:** Chỉ cần baseURL trỏ đúng (ví dụ `http://localhost:3000/api/v1` cho dev local).

---

## 3. Kế hoạch Triển khai (Implementation Plan)

### Phase 1: Chuẩn hóa Contract & Cấu hình (Ưu tiên cao)

| Bước | Nội dung | Trách nhiệm |
|------|----------|-------------|
| 1.1 | **Thống nhất API contract** với backend: response Login (token vs access_token, có `user` hay không), path user (`/me` hay `/users/me`). | Dev + Backend |
| 1.2 | **Cập nhật iOS theo contract đã chốt:** | iOS |
| | - `LoginResponseDTO`: thêm `user: UserDTO?` và/hoặc đổi key `token` ↔ `access_token` nếu backend dùng `token`. | |
| | - `AuthDTOMapper`: map `user` → entity nếu có. | |
| | - `UserEndpoint`: đổi path sang `/me` nếu backend dùng `/me`. | |
| 1.3 | **Cấu hình base URL cho local backend:** | iOS |
| | - Thêm trong Config (ví dụ `Local.xcconfig`) hoặc biến: `API_BASE_URL = http://localhost:3000/api/v1`. | |
| | - Đảm bảo BuildConfiguration đọc `API_BASE_URL` (hoặc tương đương) và AppEnvironment.baseURL dùng đúng. | |

### Phase 2: Backend đủ chức năng (theo Guide)

| Bước | Nội dung | Trách nhiệm |
|------|----------|-------------|
| 2.1 | Khởi tạo project Node (Express), cấu trúc thư mục (routes, middleware, models). | Backend |
| 2.2 | Triển khai DB theo **Database Schema** trong Guide (users, todos, FK, cascade). | Backend |
| 2.3 | Auth: JWT issue/verify, middleware bảo vệ route; `POST /auth/login`, `POST /auth/register`; response đúng contract đã chốt. | Backend |
| 2.4 | User: `GET /me` hoặc `GET /users/me` (theo quyết định 1.1), trả đủ field (id, email, name, avatar_url). | Backend |
| 2.5 | Todos: `GET/POST /todos`, `PATCH /todos/:id/toggle`, `DELETE /todos/:id`; gắn user từ JWT; trả format đúng (id, title, is_completed, created_at). | Backend |
| 2.6 | CORS cho `localhost` (và staging/production nếu cần). | Backend |

### Phase 3: Bổ sung Register trên iOS (nếu product cần)

| Bước | Nội dung | Trách nhiệm |
|------|----------|-------------|
| 3.1 | **Data:** RegisterRequestDTO, RegisterResponseDTO (hoặc dùng chung với Login nếu giống); AuthEndpoint.register; AuthRemoteDataSource.register. | iOS |
| 3.2 | **Domain:** RegisterUseCase, gọi AuthRepository.register. | iOS |
| 3.3 | **Presentation:** Màn Register (ViewController/View), RegisterViewModel, điều hướng từ Login. | iOS |

### Phase 4: Kiểm thử & Ổn định

| Bước | Nội dung | Trách nhiệm |
|------|----------|-------------|
| 4.1 | E2E: Login → Get /me → CRUD Todos với backend local. | QA / Dev |
| 4.2 | Kiểm tra token hết hạn / refresh (nếu backend hỗ trợ) và AuthInterceptor. | iOS + Backend |
| 4.3 | Cập nhật tài liệu: BackendIntegrationGuide.md (paths, response mẫu cuối cùng). | Dev |

---

## 4. Checklist Triển khai (Implementation Checklist)

### iOS

- [x] Thống nhất với backend: Login/Register response format và path `/me` vs `/users/me` (iOS đã align theo Guide).
- [x] Cập nhật `LoginResponseDTO` / `AuthDTOMapper` theo contract (token hoặc access_token, user optional; mapper `toUser`).
- [x] Cập nhật `UserEndpoint.path` sang `/me`; Auth paths sang `/auth/login`, `/auth/logout`, `/auth/refresh` (relative to base).
- [x] Thêm cấu hình base URL local: `Config/Local.xcconfig`, scheme "BaseIOSApp (Local)", Info.plist nhận `$(API_BASE_URL)`.
- [x] Thêm Register: DTO (dùng chung LoginRequestDTO/LoginResponseDTO), Endpoint, DataSource, UseCase, RegisterViewModel, RegisterViewController, AuthCoordinator.showRegister(), nút "Sign up" trên Login.

### Backend

- [x] Project Express + DB (schema users, todos như Guide) – **base-ios-backend** (thư mục tách biệt, không nằm trong BaseIOSApp).
- [x] Auth: JWT, login, register, middleware protect.
- [x] GET /me, GET/POST/PATCH/DELETE todos với user từ JWT.
- [x] CORS, base URL `/api/v1`.

### Tài liệu & QA

- [ ] Cập nhật BackendIntegrationGuide.md với contract cuối cùng.
- [ ] Test E2E: Login → Profile → Todos CRUD.

---

## 5. Tóm tắt

- **iOS:** Đã sẵn sàng tích hợp API; cần **chuẩn hóa contract** (response auth, path user) và **cấu hình base URL** cho backend local.
- **Backend:** Cần **nâng cấp** từ mẫu in-memory lên **Auth + DB** đúng schema và API trong Guide.
- **Kế hoạch:** (1) Chuẩn hóa contract & cấu hình, (2) Triển khai backend đủ tính năng, (3) Bổ sung Register trên iOS nếu cần, (4) Kiểm thử và cập nhật tài liệu.

Sau khi hoàn thành Phase 1 và 2, client và server có thể tích hợp đầy đủ theo BackendIntegrationGuide.

---

## 6. Đã triển khai (Phase 1 – iOS)

- **AuthDTO / AuthDTOMapper:** `LoginResponseDTO` nhận cả `token` và `access_token`, thêm `user: UserDTO?`; mapper có `toUser(_:)` trả `UserEntity?`.
- **AuthEndpoint:** path đổi thành relative to base: `/auth/login`, `/auth/logout`, `/auth/refresh`.
- **UserEndpoint:** path đổi thành `/me` (theo Guide).
- **Local.xcconfig:** `API_BASE_URL = http://localhost:3000/api/v1`, `ENABLE_MOCK_SERVER = NO`.
- **Info.plist:** thêm `API_BASE_URL`, `ENABLE_LOGGING`, `ENABLE_MOCK_SERVER` với giá trị `$(...)` từ xcconfig.
- **project.yml:** thêm config `Local` và scheme **"BaseIOSApp (Local)"** dùng Local.xcconfig.

**Sau khi sửa project.yml:** chạy `xcodegen generate` (và `pod install` nếu dùng CocoaPods) để cập nhật Xcode project và thấy scheme "BaseIOSApp (Local)".

---

## 7. Đã triển khai (Phase 2 – Backend)

Backend Node.js là **project riêng**, thư mục **base-ios-backend** (tách biệt hoàn toàn với BaseIOSApp, ví dụ ngang cấp: `~/base-ios-backend`).

**Vai trò backend:** Nhận API từ client → thực hiện logic & Database → trả kết quả kèm **mã HTTP** để client xử lý.

- **Cấu trúc:** `server.js`, `config.js`, `db/`, `middleware/auth.js`, `routes/auth.js`, `routes/me.js`, `routes/todos.js`.
- **DB:** SQLite (`better-sqlite3`), bảng `users` và `todos` theo schema Guide, FK + cascade.
- **Auth:** JWT (`jsonwebtoken`), bcrypt; `POST /auth/login`, `POST /auth/register`; response `{ token, user }`.
- **Middleware:** `authMiddleware` verify Bearer token, gắn `req.user = { id, email }`.
- **Routes:** `GET /me` (auth), `GET/POST /todos`, `PATCH /todos/:id/toggle`, `DELETE /todos/:id` (scoped by `user_id`).
- **CORS:** bật cho dev; base path `/api/v1`.

**Chạy backend:** `cd base-ios-backend && npm install && npm start` (hoặc `npm run dev`). Xem README trong repo **base-ios-backend**.
