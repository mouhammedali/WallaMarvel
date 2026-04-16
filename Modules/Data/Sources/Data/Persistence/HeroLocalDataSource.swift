import Foundation
import Domain

public protocol HeroLocalDataSourceProtocol: Sendable {
    func fetchAllHeroes() async throws -> [Hero]
    func storeHeroes(_ heroes: [Hero]) async throws
    func deleteAll() async throws
}
