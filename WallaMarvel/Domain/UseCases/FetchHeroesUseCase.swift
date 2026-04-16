import Foundation

/// Use cases are thin wrappers today, but they serve as the place to compose
/// cross-cutting concerns (caching policies, analytics, A/B flags) without
/// leaking those details into ViewModels or repositories.
protocol FetchHeroesUseCaseProtocol {
    func execute(offset: Int, limit: Int) async throws -> HeroesPage
}

struct FetchHeroesUseCase: FetchHeroesUseCaseProtocol {
    private let repository: HeroRepositoryProtocol

    init(repository: HeroRepositoryProtocol) {
        self.repository = repository
    }

    func execute(offset: Int, limit: Int) async throws -> HeroesPage {
        try await repository.fetchHeroes(offset: offset, limit: limit)
    }
}
