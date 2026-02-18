# Maintenance & Customization Guide

Tài liệu này hướng dẫn cách bảo trì và mở rộng hệ thống "Project Factory" để đảm bảo tính ổn định lâu dài.

## 1. Kiến Trúc "Generic-First"

Hệ thống hiện tại đã được loại bỏ hoàn toàn các thành phần iBank. Mọi code trong `Templates/` đều mang tính nền tảng (Foundation).

### Luồng Hoạt Động:
1.  **Templates/**: Nơi chứa "blueprint" (bản vẽ). Nếu bạn muốn đổi logic Networking cho **tất cả** dự án tương lai, hãy sửa ở đây.
2.  **Tools/**: Chứa các script generation. Nếu bạn đổi tên module trong template, phải cập nhật script tìm kiếm/thay thế tại đây.
3.  **Sources/**: Đây là code của Swift Package. Chỉ dùng để build app demo hoặc test package độc lập.

## 2. Bảo Trì Các Thành Phần Mới

### Hệ Thống Màu (Adaptive Colors)
Nếu bạn muốn đổi màu mặc định của bộ khung:
- Sửa `Templates/Foundation/UI/DesignSystem/Tokens/Colors.swift`.
- Sử dụng `UIColor.dynamic(light:dark:)` để luôn hỗ trợ Dark Mode.

### Lớp Lưu Trữ (Standardized Persistence)
Để thêm một database engine mới (ví dụ: CouchDB):
1.  Tạo implementation tuân thủ `StorageProtocol`.
2.  Thêm lựa chọn vào `generate_foundation.sh`.
3.  Đảm bảo code implementation nằm trong `Templates/Foundation/Core/`.

## 3. Quy trình Đóng Gói (Versioning)

Khi có thay đổi lớn:
1.  Cập nhật `Package.swift`.
2.  Chạy `sync_project.sh` để kiểm tra build package.
3.  Gắn Tag git để quản lý phiên bản ổn định.

---

## 🛠 Tóm tắt trách nhiệm
| Đối tượng | Trách nhiệm |
| :--- | :--- |
| **`Templates/`** | **Trái tim**. Mọi thay đổi về logic "chuẩn" phải được thực hiện ở đây. |
| **`Tools/`** | Quản lý logic sinh code, thay thế placeholder (`{{PROJECT_NAME}}`). |
| **`Docs/`** | Cập nhật cả tiếng Anh và tiếng Việt khi có interface mới. |

