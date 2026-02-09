
import XCTest
import Combine
import Swinject
@testable import BaseIOSApp

// MARK: - Mocks

final class MockFetchTodosUseCase: FetchTodosUseCaseProtocol {
    var executeResult: Result<[TodoItem], Error> = .success([])
    func execute() async throws -> [TodoItem] {
        try executeResult.get()
    }
}

final class MockCreateTodoUseCase: CreateTodoUseCaseProtocol {
    var executeResult: Result<TodoItem, Error>?
    func execute(title: String) async throws -> TodoItem {
        if let result = executeResult { return try result.get() }
        return TodoItem(title: title)
    }
}

final class MockToggleTodoUseCase: ToggleTodoUseCaseProtocol {
    var executeResult: Result<TodoItem, Error>?
    func execute(id: String) async throws -> TodoItem {
        if let result = executeResult { return try result.get() }
        return TodoItem(id: id, title: "Mock", isCompleted: true)
    }
}

final class MockDeleteTodoUseCase: DeleteTodoUseCaseProtocol {
    var executeError: Error?
    func execute(id: String) async throws {
        if let error = executeError { throw error }
    }
}

final class MockTodoTrackerCoordinator: Coordinator {
    var navigationController: UINavigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    func start() {}
    func finish() {}
    func addChild(_ coordinator: Coordinator) {}
    func removeChild(_ coordinator: Coordinator) {}
}

// MARK: - Tests

final class TodoTrackerViewModelTests: XCTestCase {
    var sut: TodoTrackerViewModel!
    var mockFetch: MockFetchTodosUseCase!
    var mockCreate: MockCreateTodoUseCase!
    var mockToggle: MockToggleTodoUseCase!
    var mockDelete: MockDeleteTodoUseCase!
    var mockCoordinator: TodoTrackerCoordinator!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockFetch = MockFetchTodosUseCase()
        mockCreate = MockCreateTodoUseCase()
        mockToggle = MockToggleTodoUseCase()
        mockDelete = MockDeleteTodoUseCase()
        
        // let container = Swinject.Container() // Dummy container
        mockCoordinator = TodoTrackerCoordinator(navigationController: UINavigationController(), diContainer: DIContainer.shared)
        
        sut = TodoTrackerViewModel(
            fetchTodosUseCase: mockFetch,
            createTodoUseCase: mockCreate,
            toggleTodoUseCase: mockToggle,
            deleteTodoUseCase: mockDelete,
            coordinator: mockCoordinator,
            logger: Logger.shared
        )
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }

    func test_viewDidLoad_fetchesTodos_success() async {
        // Arrange
        let expectedItems = [TodoItem(id: "1", title: "Test", isCompleted: false)]
        mockFetch.executeResult = .success(expectedItems)
        
        // Act
        let expectation = expectation(description: "State becomes loaded")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded(let items) = state, items.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
            
        sut.viewDidLoad()
        
        // Assert
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_createTodo_success() async {
        // Arrange
        let newItem = TodoItem(id: "2", title: "New Task", isCompleted: false)
        mockCreate.executeResult = .success(newItem)
        
        // Act
        await sut.createTodo(title: "New Task")
        
        // Assert
        // Async wait for state update
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .loaded(let items) = sut.state {
            XCTAssertTrue(items.contains(where: { $0.id == "2" }))
        } else {
            XCTFail("State should be loaded")
        }
    }
}
