
import XCTest

class BaseIOSAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments.append("ENABLE_MOCK_SERVER")
        app.launchArguments.append("RESET_STATE")
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLaunch() throws {
        app.launch()
        print("testLaunch hierarchy: \(app.debugDescription)")
        XCTAssertTrue(app.exists)
    }
}
