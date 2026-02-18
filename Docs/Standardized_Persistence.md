# Standardized Persistence Layer

AppFoundation features a unified, protocol-based persistence layer that abstracts data storage, allowing you to swap storage engines (SwiftData, Realm, JSON) with minimal impact on your business logic.

## 🏗 Architecture

The layer is split into two primary protocols to handle different data requirements.

### 1. `PersistenceProtocol` (Raw Data)
Used for storing raw `Data` objects, such as images, PDFs, or encrypted blobs.
- **Implementations**: `DiskStorage`.

### 2. `StorageProtocol` (Codable Objects)
Used for saving and retrieving Swift types that conform to `Codable`.
- **Implementations**: `JSONStorage`, `SwiftDataStorage`, `RealmStorage`.

## 📦 Available Implementations

### DiskStorage (PersistenceProtocol)
Saves raw `Data` directly to the `Caches` or `Documents` directory.
- **Best for**: Image caching, large binaries.
- **Key Methods**: `save(_:for:)`, `load(for:)`, `delete(for:)`.

### JSONStorage (StorageProtocol)
Saves `Codable` objects as individual `.json` files.
- **Best for**: Lightweight settings, simple user profiles, or when you want zero external dependencies.
- **Behavior**: Encodes/Decodes on the fly.

### SwiftDataStorage (StorageProtocol)
The modern Apple storage solution for iOS 17+.
- **Best for**: Complex relational data, SwiftUI integration, iCloud sync.
- **Note**: Requires a custom `Schema` definition in your target project.

## 💻 Usage Examples

### Reactive Repository Pattern
In a typical Repository, you would inject a `StorageProtocol`:

```swift
class UserRepository: UserRepositoryProtocol {
    private let storage: StorageProtocol
    
    init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    func saveUser(_ user: User) throws {
        try storage.save(user, for: "current_user")
    }
    
    func fetchUser() throws -> User? {
        return try storage.fetch(for: "current_user")
    }
}
```

## 🛠 Advanced Features

### Cache Strategies
The system supports `CacheStrategy` enums (e.g., `.onlyCache`, `.diskAndMemory`) to optimize performance and battery life.

### Error Handling
All operations are `throws`, allowing you to handle storage exhaustion or decoding errors gracefully at the view model level.
