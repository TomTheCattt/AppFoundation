# Chuẩn hóa mã lỗi & format response – Review

## Đã triển khai

### Backend (base-ios-backend)

1. **Format response thống nhất**
   - Thành công: `{ "success": true, "data": <payload> }`
   - Lỗi: `{ "success": false, "error": { "code": "<MÃ>", "message": "..." } }`

2. **Mã lỗi chuẩn** (`constants/errorCodes.js`):  
   `VALIDATION_ERROR`, `INVALID_CREDENTIALS`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`, `INTERNAL_ERROR`

3. **Helper** (`lib/response.js`): `sendSuccess(res, data, statusCode)`, `sendError(res, code, message, statusCode, details)`

4. **Routes & middleware** dùng `sendSuccess`/`sendError` và `errorCodes`.

### Client (BaseIOSApp)

1. **Envelope** (`APIResponseEnvelope.swift`): decode `{ success, data, error }`; `APIErrorPayload` (code, message); `EmptyData` cho response body null.

2. **APIClient**: 2xx decode `APIResponseEnvelope<T>` → trả `envelope.data`; 4xx/5xx parse body lỗi → `parseErrorBody` lấy code + message.

3. **NetworkError**: `serverError(_, _, apiCode)`, `unauthorized(apiCode)`, `forbidden(apiCode)`, `notFound(apiCode)`; property `apiCode` để map sang domain.

4. **AuthRemoteDataSource**: map `NetworkError.apiCode == "INVALID_CREDENTIALS"` → `AuthError.invalidCredentials`; logout dùng `EmptyData`.

5. **AuthError**: thêm `emailAlreadyRegistered`; `from(_:)` map `apiCode` CONFLICT/INVALID_CREDENTIALS sang domain.

## Review – Không phát sinh vấn đề

- Backend: mọi route trả đúng envelope; mã HTTP và error.code nhất quán.
- Client: mock vẫn decode T trực tiếp (không envelope); real API decode envelope và error body.
- Tương thích ngược: LoginResponseDTO vẫn nhận `token` hoặc `access_token`; AuthError.from vẫn xử lý NetworkError cũ (không apiCode).

---

## Phase 3 – Register trên iOS (đã triển khai)

- **Data:** Dùng chung `LoginRequestDTO` / `LoginResponseDTO`; `AuthEndpoint.register`; `AuthRemoteDataSource.register` (map CONFLICT → `AuthError.emailAlreadyRegistered`).
- **Domain:** `RegisterUseCase` + `RegisterUseCaseProtocol`; `AuthRepositoryProtocol.register` + `AuthRepository.register`.
- **Presentation:** `RegisterViewModel` + `RegisterViewModelProtocol`; `RegisterViewController`; `AuthCoordinator.showRegister()`; nút "Sign up" trên Login → push Register, đăng ký thành công → `didFinishAuthSuccess()`.
- **DI:** `AuthAssembly` đăng ký `RegisterUseCaseProtocol`.
- **Test mocks:** `MockAuthRepository` và `MockAuthRemoteDataSource` thêm `register` / `registerResult` / `registerCallCount`.
