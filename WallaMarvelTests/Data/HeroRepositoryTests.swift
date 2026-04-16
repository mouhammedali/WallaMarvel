import XCTest
@testable import WallaMarvel

final class HeroRepositoryTests: XCTestCase {
    private var sut: HeroRepository!
    private var mockDataSource: MockHeroRemoteDataSource!

    override func setUp() {
        super.setUp()
        mockDataSource = MockHeroRemoteDataSource()
        sut = HeroRepository(remoteDataSource: mockDataSource)
    }

    override func tearDown() {
        sut = nil
        mockDataSource = nil
        super.tearDown()
    }

    // MARK: - fetchHeroes

    func test_fetchHeroes_returnsCorrectPage() async throws {
        let dto = TestData.makeSuperheroDTO(id: 42, name: "Iron Man")
        mockDataSource.fetchAllResult = .success([dto])

        let page = try await sut.fetchHeroes(offset: 0, limit: 20)

        XCTAssertEqual(page.heroes.count, 1)
        XCTAssertEqual(page.heroes.first?.id, 42)
        XCTAssertEqual(page.heroes.first?.name, "Iron Man")
        XCTAssertEqual(page.total, 1)
    }

    func test_fetchHeroes_paginatesCorrectly() async throws {
        let dtos = (1...50).map { TestData.makeSuperheroDTO(id: $0, name: "Hero \($0)") }
        mockDataSource.fetchAllResult = .success(dtos)

        let page = try await sut.fetchHeroes(offset: 10, limit: 5)

        XCTAssertEqual(page.heroes.count, 5)
        XCTAssertEqual(page.heroes.first?.name, "Hero 11")
        XCTAssertEqual(page.total, 50)
    }

    func test_fetchHeroes_cachesAfterFirstFetch() async throws {
        mockDataSource.fetchAllResult = .success([TestData.makeSuperheroDTO()])

        _ = try await sut.fetchHeroes(offset: 0, limit: 20)
        _ = try await sut.fetchHeroes(offset: 0, limit: 20)

        XCTAssertEqual(mockDataSource.fetchAllCallCount, 1)
    }

    func test_fetchHeroes_propagatesError() async {
        mockDataSource.fetchAllResult = .failure(APIError.httpError(statusCode: 500))

        do {
            _ = try await sut.fetchHeroes(offset: 0, limit: 20)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .httpError(statusCode: 500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: - searchHeroes

    func test_searchHeroes_filtersCorrectly() async throws {
        let dtos = [
            TestData.makeSuperheroDTO(id: 1, name: "Spider-Man"),
            TestData.makeSuperheroDTO(id: 2, name: "Iron Man"),
            TestData.makeSuperheroDTO(id: 3, name: "Spider-Woman")
        ]
        mockDataSource.fetchAllResult = .success(dtos)

        let page = try await sut.searchHeroes(query: "Spider", offset: 0, limit: 20)

        XCTAssertEqual(page.heroes.count, 2)
        XCTAssertEqual(page.total, 2)
    }

    func test_searchHeroes_isCaseInsensitive() async throws {
        mockDataSource.fetchAllResult = .success([TestData.makeSuperheroDTO(id: 1, name: "Batman")])

        let page = try await sut.searchHeroes(query: "batman", offset: 0, limit: 20)

        XCTAssertEqual(page.heroes.count, 1)
    }

    // MARK: - fetchHeroDetail

    func test_fetchHeroDetail_returnsMatchingHero() async throws {
        let dtos = [
            TestData.makeSuperheroDTO(id: 1, name: "Thor"),
            TestData.makeSuperheroDTO(id: 2, name: "Loki")
        ]
        mockDataSource.fetchAllResult = .success(dtos)

        let hero = try await sut.fetchHeroDetail(id: 2)

        XCTAssertEqual(hero.name, "Loki")
    }

    func test_fetchHeroDetail_throwsWhenNotFound() async {
        mockDataSource.fetchAllResult = .success([TestData.makeSuperheroDTO(id: 1, name: "Thor")])

        do {
            _ = try await sut.fetchHeroDetail(id: 999)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .noData)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
