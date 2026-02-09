
import Foundation

protocol TodoTrackerRepositoryProtocol {
    func fetchTodos() async throws -> [TodoItem]
    func createTodo(title: String) async throws -> TodoItem
    func toggleTodo(id: String) async throws -> TodoItem
    func deleteTodo(id: String) async throws
}
