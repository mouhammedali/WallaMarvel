import Foundation
import Domain
import Networking

public final class MockHeroRepository: HeroRepositoryProtocol {
    public var fetchHeroesResult: Result<HeroesPage, Error> = .failure(APIError.noData)
    public var searchHeroesResult: Result<HeroesPage, Error> = .failure(APIError.noData)
    public var fetchHeroDetailResult: Result<Hero, Error> = .failure(APIError.noData)

    public var fetchHeroesCallCount = 0
    public var searchHeroesCallCount = 0
    public var fetchHeroDetailCallCount = 0

    public var lastFetchOffset: Int?
    public var lastSearchQuery: String?

    public init() {}

    public func fetchHeroes(offset: Int, limit: Int) async throws -> HeroesPage {
        fetchHeroesCallCount += 1
        lastFetchOffset = offset
        return try fetchHeroesResult.get()
    }

    public func searchHeroes(query: String, offset: Int, limit: Int) async throws -> HeroesPage {
        searchHeroesCallCount += 1
        lastSearchQuery = query
        return try searchHeroesResult.get()
    }

    public func fetchHeroDetail(id: Int) async throws -> Hero {
        fetchHeroDetailCallCount += 1
        return try fetchHeroDetailResult.get()
    }
}
