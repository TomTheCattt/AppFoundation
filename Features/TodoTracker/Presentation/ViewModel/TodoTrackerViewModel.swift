
import Foundation
import Combine
import SwiftUI

enum TodoTrackerViewState {
    case idle
    case loading
    case loaded([TodoItem])
    case empty
    case error(Error)
}

final class TodoTrackerViewModel: ObservableObject {
    @Published private(set) var state: TodoTrackerViewState = .idle
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?

    private let fetchTodosUseCase: FetchTodosUseCaseProtocol
    private let createTodoUseCase: CreateTodoUseCaseProtocol
    private let toggleTodoUseCase: ToggleTodoUseCaseProtocol
    private let deleteTodoUseCase: DeleteTodoUseCaseProtocol
    private let coordinator: TodoTrackerCoordinator
    private let logger: Logger

    // Local cache to support optimistic UI updates or cleaner state management
    private var items: [TodoItem] = []

    init(
        fetchTodosUseCase: FetchTodosUseCaseProtocol,
        createTodoUseCase: CreateTodoUseCaseProtocol,
        toggleTodoUseCase: ToggleTodoUseCaseProtocol,
        deleteTodoUseCase: DeleteTodoUseCaseProtocol,
        coordinator: TodoTrackerCoordinator,
        logger: Logger
    ) {
        self.fetchTodosUseCase = fetchTodosUseCase
        self.createTodoUseCase = createTodoUseCase
        self.toggleTodoUseCase = toggleTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
        self.coordinator = coordinator
        self.logger = logger
    }

    func viewDidLoad() {
        logger.info("TodoTrackerViewModel - viewDidLoad")
        Task { await fetchTodos() }
    }

    @MainActor
    func fetchTodos() async {
        guard !isLoading else { return }
        isLoading = true
        state = .loading
        error = nil

        do {
            let fetched = try await fetchTodosUseCase.execute()
            items = fetched
            isLoading = false
            state = items.isEmpty ? .empty : .loaded(items)
            logger.info("Fetched \(items.count) todos")
        } catch {
            isLoading = false
            self.error = error
            state = .error(error)
            logger.error("Failed to fetch todos: \(error)")
        }
    }

    func refresh() {
        Task { await fetchTodos() }
    }

    @MainActor
    func createTodo(title: String) {
        guard !title.isEmpty else { return }
        isLoading = true
        
        Task {
            do {
                let newItem = try await createTodoUseCase.execute(title: title)
                items.append(newItem)
                state = .loaded(items)
                isLoading = false
                logger.info("Created todo: \(newItem.id)")
            } catch {
                isLoading = false
                self.error = error
                logger.error("Failed to create todo: \(error)")
            }
        }
    }

    @MainActor
    func toggleTodo(id: String) {
        // Optimistic update could go here, but requirements say rely on API
        isLoading = true
        
        Task {
            do {
                let updatedItem = try await toggleTodoUseCase.execute(id: id)
                if let index = items.firstIndex(where: { $0.id == id }) {
                    items[index] = updatedItem
                }
                state = .loaded(items)
                isLoading = false
                logger.info("Toggled todo: \(id)")
            } catch {
                isLoading = false
                self.error = error
                logger.error("Failed to toggle todo: \(error)")
            }
        }
    }

    @MainActor
    func deleteTodo(id: String) {
        isLoading = true
        
        Task {
            do {
                try await deleteTodoUseCase.execute(id: id)
                items.removeAll { $0.id == id }
                state = items.isEmpty ? .empty : .loaded(items)
                isLoading = false
                logger.info("Deleted todo: \(id)")
            } catch {
                isLoading = false
                self.error = error
                logger.error("Failed to delete todo: \(error)")
            }
        }
    }

    func showAddTodoScreen() {
        // Coordinator navigation (if separate screen needed, else inline)
        // For this sample, we might use an alert or simple input in View
    }
}
