import XCTest

final class WallaMarvelUITests: XCTestCase {

    private var app: XCUIApplication!

    // The Superhero API returns ~730 heroes in a single JSON (~2MB).
    // First load can take time depending on network conditions.
    private let networkTimeout: TimeInterval = 30

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // MARK: - Helpers

    /// Waits for heroes to load by looking for the first hero's text.
    private func waitForHeroesToLoad() {
        let firstHero = app.staticTexts["A-Bomb"]
        XCTAssertTrue(
            firstHero.waitForExistence(timeout: networkTimeout),
            "Heroes should load from the API within \(Int(networkTimeout))s"
        )
    }

    /// Navigates to the first hero's detail screen.
    private func navigateToFirstHeroDetail() {
        waitForHeroesToLoad()
        app.staticTexts["A-Bomb"].firstMatch.tap()

        // Verify navigation occurred — nav bar title changes to the hero name
        let detailNavBar = app.navigationBars["A-Bomb"]
        XCTAssertTrue(
            detailNavBar.waitForExistence(timeout: 10),
            "Should navigate to A-Bomb detail screen"
        )
    }

    // MARK: - Heroes List

    func test_heroesList_showsNavigationTitle() {
        let title = app.navigationBars["Marvel Heroes"]
        XCTAssertTrue(title.waitForExistence(timeout: 10))
    }

    func test_heroesList_showsSearchBar() {
        let searchField = app.searchFields["Search heroes by name"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
    }

    func test_heroesList_displaysHeroes() {
        waitForHeroesToLoad()
        XCTAssertTrue(app.staticTexts["A-Bomb"].exists)
    }

    func test_heroesList_showsPublisherInfo() {
        waitForHeroesToLoad()
        XCTAssertTrue(app.staticTexts["Marvel Comics"].exists)
    }

    // MARK: - Navigation to Detail

    func test_tappingHero_navigatesToDetail() {
        navigateToFirstHeroDetail()
    }

    func test_heroDetail_showsPowerStats() {
        navigateToFirstHeroDetail()

        let powerStats = app.staticTexts["Power Stats"]
        XCTAssertTrue(powerStats.waitForExistence(timeout: 5))
    }

    func test_heroDetail_showsStatLabels() {
        navigateToFirstHeroDetail()

        XCTAssertTrue(app.staticTexts["Intelligence"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Strength"].exists)
        XCTAssertTrue(app.staticTexts["Speed"].exists)
    }

    func test_heroDetail_backButtonReturnsToList() {
        navigateToFirstHeroDetail()

        app.navigationBars.buttons.firstMatch.tap()

        let listTitle = app.navigationBars["Marvel Heroes"]
        XCTAssertTrue(listTitle.waitForExistence(timeout: 5))
    }

    // MARK: - Search

    func test_search_filtersHeroesByName() {
        waitForHeroesToLoad()

        let searchField = app.searchFields["Search heroes by name"]
        searchField.tap()
        searchField.typeText("Batman")

        let batman = app.staticTexts["Batman"]
        XCTAssertTrue(batman.waitForExistence(timeout: 5))
    }

    func test_search_showsEmptyStateForNoResults() {
        waitForHeroesToLoad()

        let searchField = app.searchFields["Search heroes by name"]
        searchField.tap()
        searchField.typeText("xyznonexistent123")

        let noResults = app.staticTexts["No heroes found"]
        XCTAssertTrue(noResults.waitForExistence(timeout: 5))
    }

    // MARK: - Pagination

    func test_scrollingDown_showsMoreHeroes() {
        waitForHeroesToLoad()

        let list = app.collectionViews.firstMatch
        for _ in 0..<10 {
            list.swipeUp()
        }

        sleep(1)
        XCTAssertFalse(list.cells.allElementsBoundByIndex.isEmpty)
    }
}
