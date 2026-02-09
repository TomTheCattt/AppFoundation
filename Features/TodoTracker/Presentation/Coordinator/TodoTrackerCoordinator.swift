
import UIKit
import SwiftUI
import Swinject

final class TodoTrackerCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    private let diContainer: DIContainer
    
    init(navigationController: UINavigationController, diContainer: DIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() {
        let view = makeTodoTrackerView()
        let host = UIHostingController(rootView: view)
        navigationController.pushViewController(host, animated: true)
    }

    private func makeTodoTrackerView() -> TodoTrackerView {
        // Resolve UseCases
        let fetchUC = diContainer.resolve(FetchTodosUseCaseProtocol.self)
        let createUC = diContainer.resolve(CreateTodoUseCaseProtocol.self)
        let toggleUC = diContainer.resolve(ToggleTodoUseCaseProtocol.self)
        let deleteUC = diContainer.resolve(DeleteTodoUseCaseProtocol.self)
        let logger = diContainer.resolve(Logger.self)

        let viewModel = TodoTrackerViewModel(
            fetchTodosUseCase: fetchUC,
            createTodoUseCase: createUC,
            toggleTodoUseCase: toggleUC,
            deleteTodoUseCase: deleteUC,
            coordinator: self,
            logger: logger
        )
        
        return TodoTrackerView(viewModel: viewModel)
    }
}
