//
//  FeatureViewModel.swift
//  BaseIOSApp
//

import Foundation
import Combine

final class FeatureViewModel: FeatureViewModelProtocol {
    @Published private(set) var state: FeatureViewState = .idle
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?

    var statePublisher: AnyPublisher<FeatureViewState, Never> { $state.eraseToAnyPublisher() }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { $isLoading.eraseToAnyPublisher() }
    var errorPublisher: AnyPublisher<Error?, Never> { $error.eraseToAnyPublisher() }

    private let fetchUseCase: FetchFeatureUseCaseProtocol
    private let createUseCase: CreateFeatureUseCaseProtocol
    private let updateUseCase: UpdateFeatureUseCaseProtocol
    private let deleteUseCase: DeleteFeatureUseCaseProtocol
    private let coordinator: FeatureCoordinatorProtocol
    private let logger: Logger
    private var items: [FeatureEntity] = []

    init(
        fetchUseCase: FetchFeatureUseCaseProtocol,
        createUseCase: CreateFeatureUseCaseProtocol,
        updateUseCase: UpdateFeatureUseCaseProtocol,
        deleteUseCase: DeleteFeatureUseCaseProtocol,
        coordinator: FeatureCoordinatorProtocol,
        logger: Logger
    ) {
        self.fetchUseCase = fetchUseCase
        self.createUseCase = createUseCase
        self.updateUseCase = updateUseCase
        self.deleteUseCase = deleteUseCase
        self.coordinator = coordinator
        self.logger = logger
    }

    func viewDidLoad() {
        logger.info("FeatureViewModel - viewDidLoad")
        fetchData()
    }

    func fetchData() {
        guard !isLoading else { return }
        state = .loading
        isLoading = true
        error = nil

        Task { @MainActor in
            do {
                let fetched = try await fetchUseCase.execute()
                items = fetched
                isLoading = false
                state = fetched.isEmpty ? .empty : .loaded(fetched)
                logger.info("Fetched \(fetched.count) items")
            } catch {
                isLoading = false
                self.error = error
                state = .error(error)
                logger.error("Failed to fetch: \(error)")
            }
        }
    }

    func refresh() { fetchData() }

    func numberOfItems() -> Int { items.count }

    func item(at index: Int) -> FeatureEntity? {
        guard index >= 0 && index < items.count else { return nil }
        return items[index]
    }

    func didSelectItem(at index: Int) {
        guard let item = item(at: index) else { return }
        coordinator.showDetail(for: item)
    }

    func didTapCreate() {
        coordinator.showCreateScreen()
    }

    func didTapDelete(at index: Int) {
        guard let item = item(at: index) else { return }
        Task { @MainActor in
            do {
                try await deleteUseCase.execute(id: item.id)
                items.remove(at: index)
                state = items.isEmpty ? .empty : .loaded(items)
                logger.info("Deleted item: \(item.id)")
            } catch {
                self.error = error
                logger.error("Failed to delete: \(error)")
            }
        }
    }
}
