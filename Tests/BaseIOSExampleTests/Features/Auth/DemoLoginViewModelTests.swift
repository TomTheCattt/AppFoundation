//
//  DemoLoginViewModelTests.swift
//  BaseIOSExampleTests
//
//  Created by BaseIOSApp Package.
//

import XCTest
@testable import BaseIOSExample

class MockCoordinator: DemoAppCoordinator {
    var homeShown = false
    var loginShown = false
    
    // Override window init to avoid UI issues in tests
    init() {
        super.init(window: UIWindow())
    }
    
    override func showHome() {
        homeShown = true
    }
    
    override func showLogin() {
        loginShown = true
    }
}

class DemoLoginViewModelTests: XCTestCase {
    
    var viewModel: DemoLoginViewModel!
    var mockCoordinator: MockCoordinator!
    
    override func setUp() {
        super.setUp()
        mockCoordinator = MockCoordinator()
        viewModel = DemoLoginViewModel(coordinator: mockCoordinator)
    }
    
    func testLoginSuccess() {
        // Given
        let expectation = self.expectation(description: "Login Success")
        
        // When
        viewModel.login(email: "success", pass: "password")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertTrue(self.mockCoordinator.homeShown)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testLoginFailure() {
        // Given
        let expectation = self.expectation(description: "Login Failure")
        
        // When
        viewModel.login(email: "wrong", pass: "password")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertFalse(self.mockCoordinator.homeShown)
            XCTAssertNotNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}
