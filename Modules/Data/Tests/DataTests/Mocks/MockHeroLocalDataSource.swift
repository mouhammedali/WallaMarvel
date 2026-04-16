import Foundation
import Domain
@testable import Data

final class MockHeroLocalDataSource: HeroLocalDataSourceProtocol {
    var storedHeroes: [Hero] = []
    var fetchCallCount = 0
    var storeCallCount = 0
    var deleteAllCallCount = 0

    func fetchAllHeroes() async throws -> [Hero] {
        fetchCallCount += 1
        return storedHeroes
    }

    func storeHeroes(_ heroes: [Hero]) async throws {
        storeCallCount += 1
        storedHeroes = heroes
    }

    func deleteAll() async throws {
        deleteAllCallCount += 1
        storedHeroes = []
    }
}
