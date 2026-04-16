import XCTest

class WallaMarvelLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    @MainActor
    func test_launch_showsMainScreen() throws {
        let app = XCUIApplication()
        app.launch()

        let title = app.navigationBars["Marvel Heroes"]
        XCTAssertTrue(title.waitForExistence(timeout: 10), "App should launch to Marvel Heroes screen")

        let searchField = app.searchFields["Search heroes by name"]
        XCTAssertTrue(searchField.exists, "Search bar should be visible on launch")
    }

    @MainActor
    func test_launchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
