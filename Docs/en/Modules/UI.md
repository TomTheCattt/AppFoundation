# AppFoundationUI Module

A UI component library and architecture foundation.

## Base Architecture

### 1. View Model (`BaseViewModel`)

Inherit from `BaseViewModel` to get free state management.

```swift
class MyViewModel: BaseViewModel {
    func loadData() {
        self.isLoading = true // Shows loader on VC
        
        Task {
            // ... fetch data ...
            self.isLoading = false
        }
    }
    
    func handleError(_ error: Error) {
        self.error = error // Shows alert on VC
    }
}
```

### 2. View Controller (`BaseViewController`)

Automatically binds to `BaseViewModel` states.

```swift
class MyViewController: BaseViewController<MyViewModel> {
    
    override func setupUI() {
        super.setupUI()
        // Your UI code
    }
    
    override func setupBindings() {
        super.setupBindings()
        // Bind other properties
    }
}
```

## Standard Components

### `StandardButton`
A themed button that supports loading state.

```swift
let button = StandardButton(style: .primary)
button.setTitle("Submit", for: .normal)
button.isLoading = true // Shows spinner
```

### `StandardTextField`
A styled text field with error state support.

```swift
let textField = StandardTextField()
textField.placeholder = "Enter email"
textField.showError("Invalid email format")
```

## Coordinator Pattern

We use the Coordinator pattern to decouple navigation.

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
