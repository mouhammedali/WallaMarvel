import XCTest

/// Captures screenshots for the README.
/// Run: xcodebuild test -scheme WallaMarvelUITests -only-testing:WallaMarvelUITests/ScreenshotTests
final class ScreenshotTests: XCTestCase {

    private var app: XCUIApplication!
    private let networkTimeout: TimeInterval = 30
    private let outputDir = "/tmp/wallamarvel_screenshots"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        try? FileManager.default.createDirectory(
            atPath: outputDir,
            withIntermediateDirectories: true
        )
    }

    func test_01_captureListScreen() {
        let firstHero = app.staticTexts["A-Bomb"]
        XCTAssertTrue(firstHero.waitForExistence(timeout: networkTimeout))
        saveScreenshot(named: "screenshot_list")
    }

    func test_02_captureDetailScreen() {
        let firstHero = app.staticTexts["A-Bomb"]
        XCTAssertTrue(firstHero.waitForExistence(timeout: networkTimeout))
        firstHero.firstMatch.tap()

        let detailNavBar = app.navigationBars["A-Bomb"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 10))
        sleep(1)
        saveScreenshot(named: "screenshot_detail")
    }

    func test_03_captureSearchScreen() {
        let firstHero = app.staticTexts["A-Bomb"]
        XCTAssertTrue(firstHero.waitForExistence(timeout: networkTimeout))

        let searchField = app.searchFields["Search heroes by name"]
        searchField.tap()
        searchField.typeText("Spider")

        let result = app.staticTexts["Spider-Man"]
        XCTAssertTrue(result.waitForExistence(timeout: 5))
        saveScreenshot(named: "screenshot_search")
    }

    private func saveScreenshot(named name: String) {
        let screenshot = app.screenshot()
        let path = "\(outputDir)/\(name).png"
        try? screenshot.pngRepresentation.write(to: URL(fileURLWithPath: path))
    }
}
