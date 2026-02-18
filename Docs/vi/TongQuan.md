# Tổng Quan Về AppFoundation Package

**AppFoundation** là một hệ thống Scaffolding (sinh code) toàn diện, được thiết kế theo dạng module để làm nền tảng mở rộng cho các ứng dụng iOS hiện đại. Package cung cấp các triển khai chuẩn hóa, **hoàn toàn generic**, cho Networking, Storage, UI Components và Authentication.

## Kiến Trúc

Package được chia thành các module chuyên biệt, đã được dọn dẹp sạch các logic đặc thù của dự án cũ (như iBank):

| Module | Mô tả | Dependencies |
| :--- | :--- | :--- |
| **AppFoundation (Core)** | Hệ điều hành của package. Chứa `APIClient`, các giao thức lưu trữ chuẩn hóa (`PersistenceProtocol`, `StorageProtocol`) và `SmartRetrier`. | Alamofire, Swinject, Realm |
| **AppFoundationUI** | Các UI components tái sử dụng và **Hệ thống Design System Adaptive** hỗ trợ Light/Dark mode. | `AppFoundation`, `Kingfisher` |
| **AppFoundationAuth** | Tính năng xác thực trọn gói (Luồng Login/Register, Sinh trắc học). | `AppFoundation`, `AppFoundationUI` |

## Các Cải Tiến Cốt Lõi

### 1. Nền Tảng Generic Hoàn Toàn
Toàn bộ repository đã được rà soát để loại bỏ các tham chiếu đặc thù. Hiện tại, đây là một bộ khung "sạch", phù hợp để áp dụng nhận diện thương hiệu (branding) cho bất kỳ dự án mới nào.

### 2. Chuẩn Hóa Lớp Lưu Trữ (Persistence)
Chúng tôi đã áp dụng hệ thống giao thức kép:
- **`PersistenceProtocol`**: Lưu trữ dữ liệu thô (như `DiskStorage`).
- **`StorageProtocol`**: Lưu trữ các đối tượng `Codable` (như `JSONStorage`, `SwiftDataStorage`).
- Xem chi tiết tại [Hướng dẫn Persistence](../Standardized_Persistence.md).

### 3. Hệ Thống Design System Adaptive
Công cụ theme mới sử dụng helper `UIColor.dynamic` thay vì phải tạo Asset Catalog phức tạp.
- **Tokens**: `brandPrimary`, `brandSecondary`, `appBackground`.
- **Hỗ trợ Dark Mode**: Các sub-component tự động phản hồi khi hệ thống đổi giao diện.
- Xem chi tiết tại [Hướng dẫn Theming](../DesignSystem_Theming.md).

## Smart Networking
Sử dụng `Alamofire`, `APIClient` xử lý:
*   **Automatic Refresh**: Bắt lỗi 401 và làm mới phiên làm việc tự động.
*   **NWPathMonitor**: Theo dõi trạng thái mạng thời gian thực để tránh thử lại (retry) khi đang offline.

## Các Bước Tiếp Theo
*   [Hướng dẫn QuickStart](../QuickStart_Guide.md)
*   [Hướng dẫn Bảo trì](../Maintenance_Guide.md)
*   [Tài liệu Module Core](Modules/Core.md)

