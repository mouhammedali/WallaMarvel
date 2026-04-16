import XCTest
@testable import Domain

final class DomainTests: XCTestCase {
    func test_heroesPage_hasMore_returnsTrueWhenMoreAvailable() {
        let page = HeroesPage(heroes: [], offset: 0, total: 10)
        XCTAssertTrue(page.hasMore)
    }

    func test_heroesPage_hasMore_returnsFalseWhenAllLoaded() {
        let page = HeroesPage(heroes: [], offset: 10, total: 10)
        XCTAssertFalse(page.hasMore)
    }
}
