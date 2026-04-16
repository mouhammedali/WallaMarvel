import XCTest
@testable import WallaMarvel

@MainActor
final class HeroesListViewModelTests: XCTestCase {
    private var sut: HeroesListViewModel!
    private var mockRepository: MockHeroRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockHeroRepository()
        sut = HeroesListViewModel(
            fetchHeroesUseCase: FetchHeroesUseCase(repository: mockRepository),
            searchHeroesUseCase: SearchHeroesUseCase(repository: mockRepository)
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_isIdle() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.heroes.isEmpty)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertFalse(sut.isLoadingMore)
    }

    // MARK: - onAppear

    func test_onAppear_loadsHeroes() async {
        let page = TestData.makeHeroesPage()
        mockRepository.fetchHeroesResult = .success(page)

        await sut.onAppear()

        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.heroes.count, 1)
        XCTAssertEqual(mockRepository.fetchHeroesCallCount, 1)
    }

    func test_onAppear_onError_setsErrorState() async {
        mockRepository.fetchHeroesResult = .failure(APIError.httpError(statusCode: 500))

        await sut.onAppear()

        if case .error = sut.state {
            // Pass
        } else {
            XCTFail("Expected error state, got \(sut.state)")
        }
    }

    func test_onAppear_calledTwice_onlyFetchesOnce() async {
        mockRepository.fetchHeroesResult = .success(TestData.makeHeroesPage())

        await sut.onAppear()
        await sut.onAppear()

        XCTAssertEqual(mockRepository.fetchHeroesCallCount, 1)
    }

    // MARK: - Pagination

    func test_loadNextPage_appendsHeroes() async {
        let hero1 = TestData.makeHero(id: 1, name: "Hero 1")
        let hero2 = TestData.makeHero(id: 2, name: "Hero 2")

        mockRepository.fetchHeroesResult = .success(TestData.makeHeroesPage(heroes: [hero1], total: 100))
        await sut.onAppear()

        mockRepository.fetchHeroesResult = .success(TestData.makeHeroesPage(heroes: [hero2], offset: 1, total: 100))
        await sut.loadNextPage()

        XCTAssertEqual(sut.heroes.count, 2)
        XCTAssertEqual(sut.heroes.last?.name, "Hero 2")
    }

    func test_loadNextPage_doesNotLoadWhenNoMorePages() async {
        let hero = TestData.makeHero(id: 1)
        mockRepository.fetchHeroesResult = .success(TestData.makeHeroesPage(heroes: [hero], total: 1))
        await sut.onAppear()

        mockRepository.fetchHeroesCallCount = 0
        await sut.loadNextPage()

        XCTAssertEqual(mockRepository.fetchHeroesCallCount, 0)
    }

    // MARK: - Retry

    func test_retry_reloadsAfterError() async {
        mockRepository.fetchHeroesResult = .failure(APIError.httpError(statusCode: 500))
        await sut.onAppear()

        mockRepository.fetchHeroesResult = .success(TestData.makeHeroesPage())
        await sut.retry()

        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.heroes.count, 1)
    }

    // MARK: - hasMorePages

    func test_hasMorePages_trueWhenMoreAvailable() async {
        mockRepository.fetchHeroesResult = .success(TestData.makeHeroesPage(heroes: [TestData.makeHero()], total: 100))
        await sut.onAppear()

        XCTAssertTrue(sut.hasMorePages)
    }

    func test_hasMorePages_falseWhenAllLoaded() async {
        mockRepository.fetchHeroesResult = .success(TestData.makeHeroesPage(heroes: [TestData.makeHero()], total: 1))
        await sut.onAppear()

        XCTAssertFalse(sut.hasMorePages)
    }
}
