
import Foundation

final class TodoTrackerRepository: TodoTrackerRepositoryProtocol {
    private let remote: TodoTrackerRemoteDataSourceProtocol
    private let logger: Logger

    init(remote: TodoTrackerRemoteDataSourceProtocol, logger: Logger) {
        self.remote = remote
        self.logger = logger
    }

    func fetchTodos() async throws -> [TodoItem] {
        logger.info("TodoTrackerRepository - fetchTodos")
        let dtos = try await remote.fetchTodos()
        return dtos.map { $0.toDomain() }
    }

    func createTodo(title: String) async throws -> TodoItem {
        logger.info("TodoTrackerRepository - createTodo: \(title)")
        let dto = try await remote.createTodo(title: title)
        return dto.toDomain()
    }

    func toggleTodo(id: String) async throws -> TodoItem {
        logger.info("TodoTrackerRepository - toggleTodo: \(id)")
        let dto = try await remote.toggleTodo(id: id)
        return dto.toDomain()
    }

    func deleteTodo(id: String) async throws {
        logger.info("TodoTrackerRepository - deleteTodo: \(id)")
        try await remote.deleteTodo(id: id)
    }
}
