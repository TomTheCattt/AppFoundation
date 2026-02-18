# Quy Trình Git (Git Workflow)

Tài liệu này quy định cách làm việc với Git cho dự án sử dụng BaseIOSApp Package để đảm bảo lịch sử code rõ ràng và dễ quản lý.

---

## 1. Branching Strategy (Chiến lược Nhánh)

Chúng ta sử dụng biến thể của **Gitflow Workflow**.

### Các nhánh chính:
-   **`main`**: Chứa code Production ổn định nhất. Chỉ merge từ `develop` hoặc `hotfix`.
-   **`develop`**: Nhánh phát triển chính. Chứa tính năng mới nhất đã được test.

### Các nhánh tạm thời:
-   **`feature/tên-tính-năng`**:
    -   Tạo từ: `develop`.
    -   Mục đích: Phát triển tính năng mới.
    -   Ví dụ: `feature/login-screen`, `feature/update-profile`.
-   **`bugfix/tên-lỗi`**:
    -   Tạo từ: `develop`.
    -   Mục đích: Sửa lỗi không nghiêm trọng trong quá trình phát triển.
    -   Ví dụ: `bugfix/fix-login-btn`.
-   **`hotfix/tên-lỗi`**:
    -   Tạo từ: `main`.
    -   Mục đích: Sửa lỗi nghiêm trọng trên Production cần release gấp.
    -   Ví dụ: `hotfix/crash-on-launch`.

---

## 2. Commit Convention (Quy ước Commit)

Sử dụng chuẩn **Conventional Commits** để dễ đọc và tự động tạo Changelog.

### Format:
```
<type>(<scope>): <description>

[body] (optional)
```

### Các Type phổ biến:
-   **feat**: Tính năng mới (VD: `feat(auth): thêm màn hình login`).
-   **fix**: Sửa lỗi (VD: `fix(core): sửa lỗi crash khi mất mạng`).
-   **docs**: Thay đổi tài liệu (VD: `docs: cập nhật hướng dẫn API`).
-   **style**: Format code, không đổi logic (VD: `style: chạy swiftlint`).
-   **refactor**: Tái cấu trúc code (VD: `refactor(ui): tách component button`).
-   **test**: Thêm test case (VD: `test(auth): thêm unit test cho login`).
-   **chore**: Các việc vặt khác (VD: `chore: cập nhật version package`).

### Ví dụ Commit tốt:
> `feat(ui): add Dark Mode support for BaseButton`
> `fix(net): handle timeout error correctly in APIClient`

---

## 3. Pull Request (PR) Process

1.  **Tạo PR**: Khi hoàn thành Feature/Bugfix, tạo Pull Request vào nhánh `develop`.
2.  **Mô tả PR**:
    -   Điền đầy đủ thông tin: "Làm gì?", "Tại sao?", "Ảnh chụp màn hình (nếu có UI)".
3.  **Review Code**:
    -   Cần ít nhất 1 người review (Approve) trước khi merge.
    -   CI Pipeline (Build/Test) phải xanh (Pass).
4.  **Merge**:
    -   Sử dụng "Squash and Merge" để giữ lịch sử Git gọn gàng (gom nhiều commit nhỏ thành 1 commit hoàn chỉnh).
