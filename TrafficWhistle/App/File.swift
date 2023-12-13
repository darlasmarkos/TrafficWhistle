import XCTest

class ProfileViewUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    func testSignOutButton() {
        app.buttons["Sign Out"].tap()
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    func testDeleteAccountButton() {
        app.buttons["Delete Account"].tap()
        XCTAssertTrue(app.alerts["Delete Account"].exists)
    }
}
