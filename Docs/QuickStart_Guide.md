# QuickStart Guide: Project Factory iOS

Chào mừng bạn đến với hệ thống Scaffolding iOS chuyên nghiệp. AppFoundation hiện đã được chuẩn hóa thành một bộ khung **Generic 100%**, sẵn sàng cho mọi dự án.

## 🛠 1. Chuẩn bị (Prerequisites)

- **Xcode** (15.0 trở lên).
- **CocoaPods**: Cài đặt bằng lệnh `sudo gem install cocoapods`.
- **XcodeGen**: Khuyên dùng để đồng bộ dự án (`brew install xcodegen`).

## 🚀 2. Khởi tạo dự án (The First Run)

### **Bước A: Chạy Script khởi tạo**
```bash
cd /Users/tomthecat/AppFoundation/Tools
./generate_foundation.sh
```

### **Bước B: Cấu hình Wizard**
- **Framework**: Chọn UIKit hoặc SwiftUI.
- **Storage**: Chọn JSON (nhẹ) hoặc SwiftData (hiện đại).
- **Adaptive Theme**: Hệ thống sẽ tự động thiết lập hỗ trợ Light/Dark mode.

## 🏗 3. Tài liệu chuyên sâu

Để nắm vững các cải tiến mới nhất, hãy đọc các tài liệu chi tiết sau:

- 🎨 [**Hướng dẫn Theming & Design System**](DesignSystem_Theming.md): Cách dùng `brandPrimary` và `UIColor.dynamic`.
- 💾 [**Hướng dẫn Persistence Layer**](Standardized_Persistence.md): Hiểu về `StorageProtocol` và các bộ nhớ đệm.
- 🔧 [**Hướng dẫn Bảo trì**](Maintenance_Guide.md): Cách tùy chỉnh các template gốc.

---

## 💡 Mẹo cho Pro-Developer:

1.  **Adaptive Colors**: Luôn dùng `DesignSystemColors.brandPrimary` thay vì màu hệ thống để đảm bảo tính nhất quán của thương hiệu.
2.  **Global HUD**: Gọi `HUDManager.shared.showToast(message: "Success!")` từ bất kỳ đâu.
3.  **Sync**: Sau khi thêm file thủ công, hãy chạy `./Tools/sync_project.sh` để cập nhật Xcode.

**Chúc bạn có những trải nghiệm phát triển ứng dụng tuyệt vời!**

