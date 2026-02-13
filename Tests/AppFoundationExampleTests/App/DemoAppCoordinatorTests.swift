
import XCTest
@testable import AppFoundationExample
import UIKit

final class DemoAppCoordinatorTests: XCTestCase {
    
    func testCoordinatorStart() {
        // Given
        let window = UIWindow()
        let coordinator = DemoAppCoordinator(window: window)
        
        // When
        coordinator.start()
        
        // Then
        XCTAssertNotNil(window.rootViewController)
        XCTAssertTrue(window.rootViewController is UINavigationController, "Root VC should be a NavigationController")
        
        guard let nav = window.rootViewController as? UINavigationController else { return }
        XCTAssertFalse(nav.viewControllers.isEmpty, "Navigation stack should not be empty after start")
    }
}
