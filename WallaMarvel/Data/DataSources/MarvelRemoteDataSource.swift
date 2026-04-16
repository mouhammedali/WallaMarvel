import Foundation

protocol HeroRemoteDataSourceProtocol {
    func fetchAllHeroes() async throws -> [SuperheroDTO]
    func fetchHero(id: Int) async throws -> SuperheroDTO
}

final class SuperheroRemoteDataSource: HeroRemoteDataSourceProtocol {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func fetchAllHeroes() async throws -> [SuperheroDTO] {
        try await httpClient.request(SuperheroEndpoint.allHeroes)
    }

    func fetchHero(id: Int) async throws -> SuperheroDTO {
        try await httpClient.request(SuperheroEndpoint.hero(id: id))
    }
}
