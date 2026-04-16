import Foundation

public protocol SearchHeroesUseCaseProtocol {
    func execute(query: String, offset: Int, limit: Int) async throws -> HeroesPage
}

public struct SearchHeroesUseCase: SearchHeroesUseCaseProtocol {
    private let repository: HeroRepositoryProtocol

    public init(repository: HeroRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(query: String, offset: Int, limit: Int) async throws -> HeroesPage {
        try await repository.searchHeroes(query: query, offset: offset, limit: limit)
    }
}
