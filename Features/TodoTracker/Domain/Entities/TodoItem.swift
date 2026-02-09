
import Foundation

struct TodoItem: Identifiable, Equatable, Codable {
    let id: String
    var title: String
    var isCompleted: Bool
    let createdAt: Date

    init(id: String = UUID().uuidString, title: String, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
