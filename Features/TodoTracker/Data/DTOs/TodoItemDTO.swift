
import Foundation

struct TodoItemDTO: Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted = "is_completed"
        case createdAt = "created_at"
    }

    func toDomain() -> TodoItem {
        return TodoItem(
            id: id,
            title: title,
            isCompleted: isCompleted,
            createdAt: createdAt
        )
    }
}
