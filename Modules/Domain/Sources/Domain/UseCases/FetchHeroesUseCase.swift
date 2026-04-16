import Foundation

public protocol FetchHeroesUseCaseProtocol {
    func execute(offset: Int, limit: Int) async throws -> HeroesPage
}

public struct FetchHeroesUseCase: FetchHeroesUseCaseProtocol {
    private let repository: HeroRepositoryProtocol

    public init(repository: HeroRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(offset: Int, limit: Int) async throws -> HeroesPage {
        try await repository.fetchHeroes(offset: offset, limit: limit)
    }
}
