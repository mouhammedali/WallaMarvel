import Foundation
import Networking

public protocol HeroRemoteDataSourceProtocol: Sendable {
    func fetchAllHeroes() async throws -> [SuperheroDTO]
    func fetchHero(id: Int) async throws -> SuperheroDTO
}

public final class SuperheroRemoteDataSource: HeroRemoteDataSourceProtocol {
    private let httpClient: HTTPClient

    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    public func fetchAllHeroes() async throws -> [SuperheroDTO] {
        try await httpClient.request(SuperheroEndpoint.allHeroes)
    }

    public func fetchHero(id: Int) async throws -> SuperheroDTO {
        try await httpClient.request(SuperheroEndpoint.hero(id: id))
    }
}
