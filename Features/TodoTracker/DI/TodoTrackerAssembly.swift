
import Foundation
import Swinject

final class TodoTrackerAssembly: Assembly {
    func assemble(container: Container) {
        // Data Layer
        container.register(TodoTrackerRemoteDataSourceProtocol.self) { r in
            TodoTrackerRemoteDataSource(
                apiClient: r.resolve(APIClientProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        container.register(TodoTrackerRepositoryProtocol.self) { r in
            TodoTrackerRepository(
                remote: r.resolve(TodoTrackerRemoteDataSourceProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        // Domain Layer
        container.register(FetchTodosUseCaseProtocol.self) { r in
            FetchTodosUseCase(repository: r.resolve(TodoTrackerRepositoryProtocol.self)!)
        }
        
        container.register(CreateTodoUseCaseProtocol.self) { r in
            CreateTodoUseCase(repository: r.resolve(TodoTrackerRepositoryProtocol.self)!)
        }
        
        container.register(ToggleTodoUseCaseProtocol.self) { r in
            ToggleTodoUseCase(repository: r.resolve(TodoTrackerRepositoryProtocol.self)!)
        }
        
        container.register(DeleteTodoUseCaseProtocol.self) { r in
            DeleteTodoUseCase(repository: r.resolve(TodoTrackerRepositoryProtocol.self)!)
        }
    }
}
