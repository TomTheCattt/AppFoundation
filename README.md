# AppFoundation Platform 🚀

**AppFoundation** is a professional-grade **iOS Platform** delivered as a modular **Swift Package**. It provides a robust, scalable foundation for building high-quality iOS applications, handling the heavy lifting of Networking, Authentication, Storage, and UI standardization so you can focus on business logic.

---

## 🌟 Key Features

-   **Modular Architecture**: Split into `Core`, `UI`, `Auth`, and `Resources` for maximum flexibility.
-   **Enterprise Ready**: Built on Clean Architecture, MVVM, and Coordinator patterns.
-   **Smart Networking**: Automatic retries, offline support, and seamless token management.
-   **Complete Authentication**: Drop-in login flows with biometric support and secure session handling.
-   **Themable UI**: Dynamic theme system and reusable components.

---

## 📚 Documentation (Tài Liệu)

We provide comprehensive documentation in both English and Vietnamese.

### 🇬🇧 English Documentation
- [**Installation Guide**](Docs/en/Installation.md) - How to add AppFoundation to your project
- [**Overview & Usage**](Docs/en/Overview.md) - Full guide on architecture and usage
- **Module Guides**:
  - [Core Module](Docs/en/Modules/Core.md) - Networking, DI, Storage, Biometrics
  - [Auth Module](Docs/en/Modules/Auth.md) - Authentication flows
  - [UI Module](Docs/en/Modules/UI.md) - Base components and architecture
  - [Resources Module](Docs/en/Modules/Resources.md) - Assets and theming

### 🇻🇳 Tài Liệu Tiếng Việt
- [**Hướng Dẫn Cài Đặt**](Docs/vi/CaiDat.md) - Cách thêm AppFoundation vào dự án
- [**Tổng Quan & Hướng Dẫn**](Docs/vi/TongQuan.md) - Tài liệu chi tiết về kiến trúc
- **Hướng Dẫn Module**:
  - [Module Core](Docs/vi/Modules/Core.md) - Networking, DI, Storage, Sinh trắc học
  - [Module Auth](Docs/vi/Modules/Auth.md) - Luồng xác thực
  - [Module UI](Docs/vi/Modules/UI.md) - Thành phần giao diện cơ sở
  - [Module Resources](Docs/vi/Modules/Resources.md) - Tài nguyên và giao diện

---

## 📦 Modules

### 1. 🧠 AppFoundation (Core)
The brain of the operation. Handles logic, networking, logs, and DI.
-   **Smart Networking**: Retry policies, Auth interceptors.
-   **Security**: Keychain wrapper, Biometrics.

### 2. 🔐 AppFoundationAuth
Solves authentication once and for all.
-   **Auto-Login**: Session verification on launch.
-   **Silent Refresh**: Transparent token refreshing.

### 3. 🖥️ AppFoundationUI
A solid UI framework.
-   **Base Architecture**: `BaseViewModel`, `BaseViewController`.
-   **Components**: Standardized buttons, text fields, loaders.

### 4. 🎨 AppFoundationResources
Centralized assets and theming.
-   **Theme Engine**: Dynamic light/dark/custom themes.

---

## 🛠️ Usage

 Add the package via SPM:
 `https://github.com/YourOrg/AppFoundation.git`

 import necessary modules:
 ```swift
 import AppFoundation
 import AppFoundationUI
 ```

See [**Overview**](Docs/en/Overview.md) for detailed instructions.

---

> **AppFoundation** - *Build faster, scale better.*
