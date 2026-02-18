# Automation & Tools

Tài liệu này hướng dẫn cách thiết lập và sử dụng các công cụ tự động hóa (Automation Tools) đi kèm với BaseIOSApp Package để nâng cao hiệu suất phát triển.

---

## 1. CI/CD Pipeline (GitHub Actions)

Hệ thống CI (Continuous Integration) giúp tự động kiểm tra chất lượng code mỗi khi có thay đổi.

### Cấu hình Workflow:

File cấu hình nằm tại: `.github/workflows/ci.yml`.

### Các bước kiểm tra:

1.  **Checkout Code**: Tải source code từ repository.
2.  **Lint Code (SwiftLint)**:
    -   Kiểm tra phong cách code (Design Guidelines).
    -   Báo lỗi nếu vi phạm rule (VD: Tên biến sai, Function quá dài).
3.  **Build Package**:
    -   Biên dịch toàn bộ Package để đảm bảo không lỗi cú pháp.
    -   Hỗ trợ đa nền tảng (iOS, macOS).
4.  **Run Tests**:
    -   Chạy Unit Tests cho `BaseIOSCore`, `BaseIOSUI`, `BaseIOSAuth`.
    -   Báo cáo độ bao phủ code (Code Coverage).

### Cách kích hoạt:
Pipeline sẽ tự động chạy khi:
-   Push code lên nhánh `main`, `develop`.
-   Tạo Pull Request vào các nhánh trên.

---

## 2. Feature Generation Tool (Script Tạo Module)

Công cụ CLI giúp tạo nhanh cấu trúc thư mục và file mẫu cho một Feature mới, giúp tiết kiệm thời gian và đảm bảo chuẩn kiến trúc.

### Cài đặt & Sử dụng:

Script nằm tại: `Tools/FeatureGen/`.

Chạy lệnh sau từ Terminal (tại thư mục root dự án):

```bash
swift run feature-gen --name "UserProfile" --type "screen" --author "YourName"
```

### Tham số:
-   `--name`: Tên của Feature (Viết liền không dấu, VD: `ChatDetail`).
-   `--type`: Loại feature (Support: `screen`, `service`, `test`).
-   `--author`: Tên tác giả (để điền vào Header comment).

### Kết quả:
Tool sẽ tự động sinh ra cấu trúc thư mục chuẩn Clean Architecture:

```
Sources/BaseIOSFeatures/UserProfile/
├── Domain/
│   ├── UserProfileUseCase.swift   (Protocol + Implementation)
│   └── UserProfileEntity.swift    (Struct Model)
├── Data/
│   ├── UserProfileRepository.swift (API Implementation)
│   └── UserProfileDTO.swift       (Codable Model)
└── Presentation/
    ├── UserProfileViewModel.swift (ViewModel + Input/Output)
    └── UserProfileView.swift      (UIKit/SwiftUI View)
```

Dev chỉ cần điền logic vào các file khung sườn này thay vì copy-paste thủ công.
