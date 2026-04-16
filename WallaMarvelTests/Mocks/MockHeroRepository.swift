import Foundation
@testable import WallaMarvel

final class MockHeroRepository: HeroRepositoryProtocol {
    var fetchHeroesResult: Result<HeroesPage, Error> = .failure(APIError.noData)
    var searchHeroesResult: Result<HeroesPage, Error> = .failure(APIError.noData)
    var fetchHeroDetailResult: Result<Hero, Error> = .failure(APIError.noData)

    var fetchHeroesCallCount = 0
    var searchHeroesCallCount = 0
    var fetchHeroDetailCallCount = 0

    var lastFetchOffset: Int?
    var lastSearchQuery: String?

    func fetchHeroes(offset: Int, limit: Int) async throws -> HeroesPage {
        fetchHeroesCallCount += 1
        lastFetchOffset = offset
        return try fetchHeroesResult.get()
    }

    func searchHeroes(query: String, offset: Int, limit: Int) async throws -> HeroesPage {
        searchHeroesCallCount += 1
        lastSearchQuery = query
        return try searchHeroesResult.get()
    }

    func fetchHeroDetail(id: Int) async throws -> Hero {
        fetchHeroDetailCallCount += 1
        return try fetchHeroDetailResult.get()
    }
}
