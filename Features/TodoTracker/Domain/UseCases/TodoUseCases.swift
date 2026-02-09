
import Foundation

// MARK: - Protocols

protocol FetchTodosUseCaseProtocol {
    func execute() async throws -> [TodoItem]
}

protocol CreateTodoUseCaseProtocol {
    func execute(title: String) async throws -> TodoItem
}

protocol ToggleTodoUseCaseProtocol {
    func execute(id: String) async throws -> TodoItem
}

protocol DeleteTodoUseCaseProtocol {
    func execute(id: String) async throws
}

// MARK: - Implementations

final class FetchTodosUseCase: FetchTodosUseCaseProtocol {
    private let repository: TodoTrackerRepositoryProtocol
    
    init(repository: TodoTrackerRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [TodoItem] {
        return try await repository.fetchTodos()
    }
}

final class CreateTodoUseCase: CreateTodoUseCaseProtocol {
    private let repository: TodoTrackerRepositoryProtocol
    
    init(repository: TodoTrackerRepositoryProtocol) {
        self.repository = repository
    }

    func execute(title: String) async throws -> TodoItem {
        return try await repository.createTodo(title: title)
    }
}

final class ToggleTodoUseCase: ToggleTodoUseCaseProtocol {
    private let repository: TodoTrackerRepositoryProtocol
    
    init(repository: TodoTrackerRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws -> TodoItem {
        return try await repository.toggleTodo(id: id)
    }
}

final class DeleteTodoUseCase: DeleteTodoUseCaseProtocol {
    private let repository: TodoTrackerRepositoryProtocol
    
    init(repository: TodoTrackerRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws {
        try await repository.deleteTodo(id: id)
    }
}
