# Backend Integration Guide

## 1. Client Status & Readiness
The iOS client is **API-Ready**.
- **Architecture**: Fully supports Clean Architecture with a dedicated Network Layer (`APIClient`).
- **Data Flow**: `RemoteDataSource` -> `Repository` -> `UseCase` -> `ViewModel`.
- **API Client**: Uses `Alamofire` with support for Interceptors (Auth) and generic `Decodable` responses.
- **Example Implementation**: `TodoTracker` feature demonstrates full CRUD operations via API.

## 2. API Contract Requirements

### Common
- **Base URL**: `http://localhost:3000/api/v1` (configurable in `AppEnvironment`).
- **Headers**:
    - `Content-Type: application/json`
    - `Authorization: Bearer <token>` (for protected endpoints).

### Auth Feature (Assumed/Planned)
- `POST /auth/login`
    - Body: `{ "email": "...", "password": "..." }`
    - Response: `{ "token": "...", "user": { ... } }`
- `POST /auth/register`
    - Body: `{ "email": "...", "password": "..." }`
    - Response: `{ "token": "...", "user": { ... } }`

### User Feature
- `GET /me` (Auth required)
    - Response: `{ "id": "...", "email": "...", "name": "...", "avatar_url": "..." }`

### TodoTracker Feature
- `GET /todos` (Auth required, scoped to `user_id`)
    - Response: `[{ "id": "...", "title": "...", "is_completed": false, "created_at": "..." }]`
- `POST /todos`
    - Body: `{ "title": "...", "is_completed": false }` (Server sets `user_id` from token)
    - Response: `{ "id": "...", "title": "...", ... }`
- `PATCH /todos/:id/toggle`
    - Response: `{ "id": "...", "is_completed": true, ... }`
- `DELETE /todos/:id`
    - Response: `200 OK` (Empty Body)

## 3. Database Schema Design (Recommended)

To fully support these features, the following database schema (Relational/SQL) is recommended.

### Tables

#### `users`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` / `VARCHAR` | `PK` | Unique User ID |
| `email` | `VARCHAR(255)` | `UNIQUE`, `NOT NULL` | Login Email |
| `password_hash` | `VARCHAR` | `NOT NULL` | Hashed Password (bcrypt/argon2) |
| `name` | `VARCHAR(100)` | `NULLABLE` | Display Name |
| `avatar_url` | `TEXT` | `NULLABLE` | URL to profile image |
| `created_at` | `TIMESTAMP` | `DEFAULT NOW()` | Account creation time |
| `updated_at` | `TIMESTAMP` | `DEFAULT NOW()` | Last update time |

#### `todos`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` / `VARCHAR` | `PK` | Unique Todo ID |
| `user_id` | `UUID` / `VARCHAR` | `FK -> users.id` | Owner of the todo (NOT NULL) |
| `title` | `TEXT` | `NOT NULL` | Task content |
| `is_completed` | `BOOLEAN` | `DEFAULT FALSE` | Completion status |
| `created_at` | `TIMESTAMP` | `DEFAULT NOW()` | Creation time |
| `updated_at` | `TIMESTAMP` | `DEFAULT NOW()` | Last update time |

### Relationships
- **One-to-Many**: `users.id` -> `todos.user_id` (A user can have multiple todos).
- **Cascading**: On user delete, delete all associated todos.

## 4. Backend (tách biệt với BaseIOSApp)

**Backend** là một project riêng, **không nằm trong thư mục BaseIOSApp**. Vai trò:

- **Nhận** API được gọi từ client (iOS, web, …).
- **Thực hiện** logic nghiệp vụ và thao tác Database.
- **Trả về** kết quả (body) kèm **mã HTTP** (200, 201, 400, 401, 404, 409, 500) để client xử lý.

Project backend: **`base-ios-backend`** (thư mục ngang cấp với BaseIOSApp, ví dụ `~/base-ios-backend`).

### Prerequisites
- Node.js (v14+)
- npm hoặc yarn

### Chạy backend có sẵn (Phase 2 đã triển khai)
1.  **Vào thư mục backend** (tách biệt với BaseIOSApp):
    ```bash
    cd /path/to/base-ios-backend   # ví dụ: cd ~/base-ios-backend
    npm install
    npm start
    ```

2.  **Kết nối client (iOS)**:
    - Dùng scheme **BaseIOSApp (Local)** hoặc cấu hình `API_BASE_URL = http://localhost:3000/api/v1` (đã có trong `Config/Local.xcconfig`).
    - Client gửi request tới backend, đọc **status code** và **body** để xử lý thành công / lỗi.

Backend đầy đủ (Auth + DB + todos) xem README trong repo **base-ios-backend**.
