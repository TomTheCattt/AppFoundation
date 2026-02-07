//
//  FeatureCoordinator.swift
//  BaseIOSApp
//

import UIKit

final class FeatureCoordinator: Coordinator, FeatureCoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?

    private let diContainer: DIContainer
    private let logger: Logger

    init(navigationController: UINavigationController, diContainer: DIContainer, logger: Logger) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.logger = logger
    }

    func start() {
        logger.info("FeatureCoordinator - Starting")
        showFeatureList()
    }

    func finish() {
        logger.info("FeatureCoordinator - Finishing")
        parentCoordinator?.removeChild(self)
    }

    private func showFeatureList() {
        let viewModel = makeFeatureViewModel()
        let viewController = FeatureViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDetail(for item: FeatureEntity) {
        logger.info("Showing detail for: \(item.id)")
        // Create detail coordinator and start when implemented
    }

    func showCreateScreen() {
        logger.info("Showing create screen")
        // Create coordinator and start when implemented
    }

    func showEdit(for item: FeatureEntity) {
        logger.info("Showing edit for: \(item.id)")
        // Create edit coordinator and start when implemented
    }

    private func makeFeatureViewModel() -> FeatureViewModel {
        let fetchUseCase: FetchFeatureUseCaseProtocol = diContainer.resolve(FetchFeatureUseCaseProtocol.self)
        let createUseCase: CreateFeatureUseCaseProtocol = diContainer.resolve(CreateFeatureUseCaseProtocol.self)
        let updateUseCase: UpdateFeatureUseCaseProtocol = diContainer.resolve(UpdateFeatureUseCaseProtocol.self)
        let deleteUseCase: DeleteFeatureUseCaseProtocol = diContainer.resolve(DeleteFeatureUseCaseProtocol.self)
        let logger: Logger = diContainer.resolve(Logger.self)
        return FeatureViewModel(
            fetchUseCase: fetchUseCase,
            createUseCase: createUseCase,
            updateUseCase: updateUseCase,
            deleteUseCase: deleteUseCase,
            coordinator: self,
            logger: logger
        )
    }
}
