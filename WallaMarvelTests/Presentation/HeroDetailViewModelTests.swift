import XCTest
import Domain
import Networking
import TestHelpers
@testable import WallaMarvel

@MainActor
final class HeroDetailViewModelTests: XCTestCase {
    private var sut: HeroDetailViewModel!
    private var mockRepository: MockHeroRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockHeroRepository()
        sut = HeroDetailViewModel(
            heroId: 1,
            heroName: "Spider-Man",
            fetchHeroDetailUseCase: FetchHeroDetailUseCase(repository: mockRepository)
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_initialState_isIdle() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(sut.heroName, "Spider-Man")
    }

    func test_onAppear_loadsHeroDetail() async {
        let hero = TestData.makeHero(id: 1, name: "Spider-Man")
        mockRepository.fetchHeroDetailResult = .success(hero)

        await sut.onAppear()

        XCTAssertEqual(sut.state, .loaded(hero))
    }

    func test_onAppear_onError_setsErrorState() async {
        mockRepository.fetchHeroDetailResult = .failure(APIError.httpError(statusCode: 404))

        await sut.onAppear()

        if case .error = sut.state {
            // Pass
        } else {
            XCTFail("Expected error state, got \(sut.state)")
        }
    }

    func test_onAppear_calledTwice_onlyFetchesOnce() async {
        mockRepository.fetchHeroDetailResult = .success(TestData.makeHero())

        await sut.onAppear()
        await sut.onAppear()

        XCTAssertEqual(mockRepository.fetchHeroDetailCallCount, 1)
    }

    func test_retry_reloadsAfterError() async {
        mockRepository.fetchHeroDetailResult = .failure(APIError.noData)
        await sut.onAppear()

        let hero = TestData.makeHero(id: 1, name: "Spider-Man")
        mockRepository.fetchHeroDetailResult = .success(hero)
        await sut.retry()

        XCTAssertEqual(sut.state, .loaded(hero))
    }
}
