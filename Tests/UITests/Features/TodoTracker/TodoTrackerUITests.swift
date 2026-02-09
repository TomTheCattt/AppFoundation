
import XCTest

final class TodoTrackerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    func test_todoTracker_flow() throws {
        // Note: usage requires app to navigate to TodoTracker.
        // Assuming there is a button "Todo Tracker" on Home for testing purposes, 
        // OR the app is configured to start there.
        
        // 1. Handle Authentication State
        let todoTab = app.tabBars.buttons["Todos"]
        
        // Check if already authenticated (Todos tab exists)
        if todoTab.waitForExistence(timeout: 3) {
            // Already logged in, proceed to Todos tab
            todoTab.tap()
        } else {
            // Not authenticated, need to login/register
            // DEBUG: Print all available buttons
            print("DEBUG: All buttons:")
            app.buttons.allElementsBoundByIndex.forEach { button in
                print("  - Button: \(button.label), identifier: \(button.identifier)")
            }
            print("DEBUG: All tab bar buttons:")
            app.tabBars.buttons.allElementsBoundByIndex.forEach { tab in
                print("  - Tab: \(tab.label), identifier: \(tab.identifier)")
            }
            
            let signUpButton = app.buttons["Sign up"]
            
            if signUpButton.waitForExistence(timeout: 2) {
                // On Login screen, navigate to Register
                signUpButton.tap()
                
                // Register Screen
                let emailField = app.textFields["textField.email"]
                XCTAssertTrue(emailField.waitForExistence(timeout: 2), "Email field should exist on Register screen")
                emailField.tap()
                emailField.typeText("test_ui_\(UUID().uuidString.prefix(8))@example.com")
                
                let passwordField = app.secureTextFields["textField.password"]
                XCTAssertTrue(passwordField.exists, "Password field should exist")
                passwordField.tap()
                sleep(1) // Wait for keyboard to appear and gain focus
                passwordField.typeText("password123")
                
                let registerButton = app.buttons["button.submit"]
                registerButton.tap()
                
                // Wait for navigation to TabBar after successful registration
                XCTAssertTrue(todoTab.waitForExistence(timeout: 10), "Should navigate to Todos tab after registration")
                todoTab.tap()
            } else {
                // Neither Todos tab nor Login screen found
                XCTFail("App is in unexpected state: no Todos tab and no Login screen")
                return
            }
        }

        // 2. Add Task
        let textField = app.textFields["New Task"]
        XCTAssertTrue(textField.waitForExistence(timeout: 2), "New Task text field should exist")
        textField.tap()
        textField.typeText("Test Manual")

        let addButton = app.buttons["Add"] // Assuming generic Button, or check image
        if addButton.exists {
             addButton.tap()
        } else {
             // Fallback to image if button title not found
             app.images["plus.circle.fill"].tap()
        }

        // 3. Verify List Update
        let cellTitle = app.staticTexts["Test Manual"]
        XCTAssertTrue(cellTitle.waitForExistence(timeout: 5), "Newly added task not found")
        
        // 4. Cleanup (Optional: Toggle/Delete could be tested here)
    }
}
