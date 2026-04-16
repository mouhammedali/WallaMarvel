import Foundation
import Networking
@testable import Data

final class MockHeroRemoteDataSource: HeroRemoteDataSourceProtocol {
    var fetchAllResult: Result<[SuperheroDTO], Error> = .failure(APIError.noData)
    var fetchHeroResult: Result<SuperheroDTO, Error> = .failure(APIError.noData)

    var fetchAllCallCount = 0
    var fetchHeroCallCount = 0
    var lastFetchedHeroId: Int?

    func fetchAllHeroes() async throws -> [SuperheroDTO] {
        fetchAllCallCount += 1
        return try fetchAllResult.get()
    }

    func fetchHero(id: Int) async throws -> SuperheroDTO {
        fetchHeroCallCount += 1
        lastFetchedHeroId = id
        return try fetchHeroResult.get()
    }
}
