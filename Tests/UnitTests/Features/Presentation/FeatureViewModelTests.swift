//
//  FeatureViewModelTests.swift
//  AppFoundationTests
//

import XCTest
import Combine
@testable import AppFoundation

final class FeatureViewModelTests: XCTestCase {

    var sut: FeatureViewModel!
    var mockFetchUseCase: MockFetchFeatureUseCase!
    var mockCreateUseCase: MockCreateFeatureUseCase!
    var mockUpdateUseCase: MockUpdateFeatureUseCase!
    var mockDeleteUseCase: MockDeleteFeatureUseCase!
    var mockCoordinator: MockFeatureCoordinator!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockFetchUseCase = MockFetchFeatureUseCase()
        mockCreateUseCase = MockCreateFeatureUseCase()
        mockUpdateUseCase = MockUpdateFeatureUseCase()
        mockDeleteUseCase = MockDeleteFeatureUseCase()
        mockCoordinator = MockFeatureCoordinator()
        cancellables = Set<AnyCancellable>()
        sut = FeatureViewModel(
            fetchUseCase: mockFetchUseCase,
            createUseCase: mockCreateUseCase,
            updateUseCase: mockUpdateUseCase,
            deleteUseCase: mockDeleteUseCase,
            coordinator: mockCoordinator,
            logger: Logger.shared
        )
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockFetchUseCase = nil
        mockCreateUseCase = nil
        mockUpdateUseCase = nil
        mockDeleteUseCase = nil
        mockCoordinator = nil
        super.tearDown()
    }

    func test_viewDidLoad_fetchesData() async {
        let entities = [
            FeatureEntity(id: "1", title: "A", description: "", status: .active, priority: 1, tags: [])
        ]
        mockFetchUseCase.executeResult = .success(entities)
        let expectation = expectation(description: "state becomes loaded")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { expectation.fulfill() }
                if case .error = state { expectation.fulfill() }
            }
            .store(in: &cancellables)
        sut.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(mockFetchUseCase.executeCallCount, 1)
        XCTAssertEqual(sut.numberOfItems(), 1)
    }

    func test_numberOfItems_returnsCountAfterFetch() async {
        let entities = (1...3).map { i in
            FeatureEntity(id: "\(i)", title: "T\(i)", description: "", status: .active, priority: i, tags: [])
        }
        mockFetchUseCase.executeResult = .success(entities)
        let expectation = expectation(description: "loaded")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { expectation.fulfill() }
            }
            .store(in: &cancellables)
        sut.fetchData()
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(sut.numberOfItems(), 3)
    }

    func test_item_atValidIndex_returnsEntity() async {
        let entity = FeatureEntity(id: "e1", title: "E1", description: "", status: .active, priority: 0, tags: [])
        mockFetchUseCase.executeResult = .success([entity])
        let expectation = expectation(description: "loaded")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { expectation.fulfill() }
            }
            .store(in: &cancellables)
        sut.fetchData()
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(sut.item(at: 0)?.id, "e1")
        XCTAssertNil(sut.item(at: 1))
        XCTAssertNil(sut.item(at: -1))
    }

    func test_didSelectItem_callsCoordinatorShowDetail() async {
        let entity = FeatureEntity(id: "sel", title: "Sel", description: "", status: .active, priority: 0, tags: [])
        mockFetchUseCase.executeResult = .success([entity])
        let expectation = expectation(description: "loaded")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { expectation.fulfill() }
            }
            .store(in: &cancellables)
        sut.fetchData()
        await fulfillment(of: [expectation], timeout: 2.0)
        sut.didSelectItem(at: 0)
        XCTAssertTrue(mockCoordinator.showDetailCalled)
        XCTAssertEqual(mockCoordinator.showDetailItem?.id, "sel")
    }

    func test_didTapCreate_callsCoordinatorShowCreateScreen() {
        sut.didTapCreate()
        XCTAssertTrue(mockCoordinator.showCreateScreenCalled)
    }

    func test_refresh_callsFetchData() async {
        mockFetchUseCase.executeResult = .success([])
        let expectation = expectation(description: "empty")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .empty = state { expectation.fulfill() }
            }
            .store(in: &cancellables)
        sut.refresh()
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(mockFetchUseCase.executeCallCount, 1)
    }

    func test_didTapDelete_removesItemAndUpdatesState() async {
        let entities = [
            FeatureEntity(id: "d1", title: "D1", description: "", status: .active, priority: 0, tags: [])
        ]
        mockFetchUseCase.executeResult = .success(entities)
        mockDeleteUseCase.executeError = nil
        let loadExpectation = expectation(description: "loaded")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { loadExpectation.fulfill() }
            }
            .store(in: &cancellables)
        sut.fetchData()
        await fulfillment(of: [loadExpectation], timeout: 2.0)
        let emptyExpectation = expectation(description: "empty after delete")
        sut.statePublisher
            .sink { state in
                if case .empty = state { emptyExpectation.fulfill() }
            }
            .store(in: &cancellables)
        sut.didTapDelete(at: 0)
        await fulfillment(of: [emptyExpectation], timeout: 2.0)
        XCTAssertEqual(mockDeleteUseCase.executeCallCount, 1)
        XCTAssertEqual(sut.numberOfItems(), 0)
    }
}
