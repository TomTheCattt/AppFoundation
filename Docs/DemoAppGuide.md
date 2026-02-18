# Hướng Dẫn Chạy Demo App

Package này đi kèm với một Demo App (`BaseIOSExample`) thể hiện đầy đủ các tính năng.

## Cách chạy Demo

1.  Mở Project trong Xcode (mở file `Package.swift`).
2.  Chọn Scheme **`BaseIOSExample`** ở trên thanh công cụ.
3.  Chọn Simulator (iPhone 15/14...).
4.  Bấm Cmd+R để chạy.

## Các Tính Năng Demo

### 1. Authentication Flow
-   **Màn hình Login**:
    -   Nhập Email: `success` -> Đăng nhập thành công.
    -   Nhập khác -> Báo lỗi.
-   **Tự động Đăng nhập**:
    -   Sửa file `DemoAppCoordinator.swift` biến `hasToken = true` để simulare.

### 2. Network Demo (Smart Network)
Để test tính năng Offline Fallback:
1.  Vào mục "Smart Network & Fallback".
2.  Tắt mạng Simulator (hoặc tắt Wifi máy thật).
3.  Bấm **"Fetch (Network First)"**.
    -   Lần đầu: Sẽ báo lỗi mạng hoặc chờ (trạng thái Waiting).
4.  Bấm **"Fetch (Cache Only)"**:
    -   Nếu đã từng fetch thành công 1 lần trước đó, nó sẽ hiển thị data cũ.

### 3. Storage & Security
-   **CoreData**: Bấm nút "Test CoreData" để mô phỏng lưu object xuống DB.
-   **FaceID**: Bấm nút "Test FaceID" (cần Simulator bật FaceID Enrolled) để thấy popup xác thực.

### 4. Settings & Theme
-   Bấm "Switch to Dark Theme": Giao diện app sẽ đổi màu (Demo đổi màu nền sang đen và màu chủ đạo sang Cam).

---

## Kiểm Tra Unit Test

1.  Bấm **Cmd+U** để chạy toàn bộ Test Suite.
2.  Các Test Case bao gồm:
    -   `DemoLoginViewModelTests`: Test luồng login đúng/sai.
    -   Các test nội bộ của Package (nếu có).
