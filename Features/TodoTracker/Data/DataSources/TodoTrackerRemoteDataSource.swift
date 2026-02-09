
import Foundation

protocol TodoTrackerRemoteDataSourceProtocol {
    func fetchTodos() async throws -> [TodoItemDTO]
    func createTodo(title: String) async throws -> TodoItemDTO
    func toggleTodo(id: String) async throws -> TodoItemDTO
    func deleteTodo(id: String) async throws
}

final class TodoTrackerRemoteDataSource: TodoTrackerRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    private let logger: Logger

    init(apiClient: APIClientProtocol, logger: Logger) {
        self.apiClient = apiClient
        self.logger = logger
    }

    func fetchTodos() async throws -> [TodoItemDTO] {
        let endpoint = Endpoint(path: "/todos", method: .get)
        return try await apiClient.request(endpoint, responseType: [TodoItemDTO].self)
    }

    func createTodo(title: String) async throws -> TodoItemDTO {
        let params = ["title": title, "is_completed": false] as [String : Any]
        let body = try JSONSerialization.data(withJSONObject: params)
        let endpoint = Endpoint(path: "/todos", method: .post, body: body)
        return try await apiClient.request(endpoint, responseType: TodoItemDTO.self)
    }

    func toggleTodo(id: String) async throws -> TodoItemDTO {
        let endpoint = Endpoint(path: "/todos/\(id)/toggle", method: .patch)
        return try await apiClient.request(endpoint, responseType: TodoItemDTO.self)
    }

    func deleteTodo(id: String) async throws {
        let endpoint = Endpoint(path: "/todos/\(id)", method: .delete)
        _ = try await apiClient.request(endpoint, responseType: EmptyResponse.self)
    }
}


