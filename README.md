# BaseIOSApp Platform 🚀

**BaseIOSApp** không chỉ là một template, mà là một **"Hệ Điều Hành" (Platform)** dành cho việc phát triển ứng dụng iOS chuyên nghiệp. Nó được đóng gói dưới dạng **Swift Package** modular, giúp bạn khởi động dự án mới nhanh chóng với chuẩn mực kiến trúc cao nhất.

---

## 🌟 Tại Sao Chọn BaseIOSApp?

- **Tăng Tốc 50%**: Bỏ qua các bước setup nhàm chán (Network, Auth, Logger, DI). Tập trung ngay vào Business Logic.
- **Chuẩn Doanh Nghiệp**: Kiến trúc Clean Architecture, MVVM, Coordinator đã được kiểm chứng.
- **Linh Hoạt Tuyệt Đối**: Không bị khóa cứng giao diện. Hệ thống Theme và Injection cho phép tùy biến mọi thứ.

---

## 📦 Các Module Chính & Tính Năng

Package được chia thành 4 module độc lập, bạn có thể dùng tất cả hoặc chỉ chọn cái mình cần:

### 1. 🧠 BaseIOSCore (Bộ Não)
Xử lý logic nền tảng, hoàn toàn tách biệt với UI.
-   **Smart Networking**: 
    -   Tự động **Retry 3 lần** khi mạng chập chờn (Timeout, 5xx).
    -   Tự động **Pause/Resume** request khi mất mạng/có mạng lại.
-   **Lifecycle Management**: 
    -   Tự động khởi tạo services (Logger, DI, Database) theo đúng thứ tự.
    -   Xử lý Background/Foreground thông minh (dọn dẹp bộ nhớ, lưu state).
-   **Security**: Quản lý Token và dữ liệu nhạy cảm trong **Keychain**.

### 2. 🔐 BaseIOSAuth (Bảo Mật & Xác Thực)
Giải quyết bài toán đau đầu nhất của mọi App: **Quản lý phiên đăng nhập**.
-   **Auto-Login**: Tự động kiểm tra và verify session khi mở App.
-   **Silent Refresh Token**: 
    -   Khi Token hết hạn, hệ thống **âm thầm** lấy Token mới và thực hiện lại request.
    -   Người dùng không bị gián đoạn, không bị văng ra Login.
-   **Session Guard**: Tự động Logout và dọn dẹp data khi phiên làm việc thực sự kết thúc.

### 3. 🎨 BaseIOSResources (Tài Nguyên)
Trung tâm quản lý Assets và Design System.
-   **Centralized Assets**: Quản lý toàn bộ Ảnh, Font, Màu, String tại một nơi.
-   **Theme Engine**: 
    -   Hỗ trợ **Override** toàn bộ giao diện (Màu sắc, Font chữ) từ App con.
    -   Dễ dàng làm Dark Mode hoặc đổi Theme theo branding của đối tác.

### 4. 🖥️ BaseIOSUI (Giao Diện)
Bộ khung sườn UI vững chắc.
-   **Base Architecture**: `BaseViewModel`, `BaseViewController` xử lý sẵn State (Loading, Error, Empty).
-   **Flexible Loading**: Cho phép App con tự định nghĩa Loading View (Spinner, Skeleton, Lottie) và inject vào Base.

---

## 🛠️ Công Cụ Hỗ Trợ (Automation)

Không chỉ có Code, BaseIOSApp còn cung cấp quy trình làm việc:
-   **Feature Generator**: Tool CLI tạo module mới tự động (Domain/Data/Presentation) trong 3 giây.
-   **CI/CD Pipeline**: Template GitHub Actions để tự động Test, Lint và Build.

---

## 📚 Tài Liệu Chi Tiết

-   [Hướng Dẫn Sử Dụng (Package Usage)](Docs/PackageUsage.md)
-   [Tính Năng Nâng Cao (Advanced Features)](Docs/AdvancedFeatures.md)
-   [Quy Trình Git (Git Workflow)](Docs/GitWorkflow.md)
-   [Automation & Tools](Docs/AutomationAndTools.md)

---

> **BaseIOSApp** - *Build faster, scale better.*
