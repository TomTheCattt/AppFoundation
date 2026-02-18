# Module AppFoundationUI

Thư viện thành phần giao diện và nền tảng kiến trúc UI.

## Kiến trúc Cơ sở (Base Architecture)

### 1. View Model (`BaseViewModel`)

Thừa kế từ `BaseViewModel` để có sẵn quản lý trạng thái.

```swift
class MyViewModel: BaseViewModel {
    func loadData() {
        self.isLoading = true // Tự động hiện loader trên VC
        
        Task {
            // ... lấy dữ liệu ...
            self.isLoading = false
        }
    }
    
    func handleError(_ error: Error) {
        self.error = error // Tự động hiện alert lỗi trên VC
    }
}
```

### 2. View Controller (`BaseViewController`)

Tự động liên kết (bind) với trạng thái của `BaseViewModel`.

```swift
class MyViewController: BaseViewController<MyViewModel> {
    
    override func setupUI() {
        super.setupUI()
        // Code UI của bạn
    }
    
    override func setupBindings() {
        super.setupBindings()
        // Bind các thuộc tính khác
    }
}
```

## UI Component Chuẩn

### `StandardButton`
Nút bấm hỗ trợ theme và trạng thái loading.

```swift
let button = StandardButton(style: .primary)
button.setTitle("Gửi", for: .normal)
button.isLoading = true // Hiện spinner thay vì text
```

### `StandardTextField`
Ô nhập liệu có hỗ trợ hiển thị lỗi.

```swift
let textField = StandardTextField()
textField.placeholder = "Nhập email"
textField.showError("Email không hợp lệ")
```

## Coordinator Pattern (Điều hướng)

Chúng tôi dùng pattern này để tách biệt logic chuyển màn hình.

```swift
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

class MyCoordinator: Coordinator {
    /* ... */
    
    func showDetails(id: String) {
        let vm = DetailsViewModel(id: id)
        let vc = DetailsViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
```
