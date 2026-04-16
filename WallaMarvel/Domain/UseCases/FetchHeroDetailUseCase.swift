import Foundation

protocol FetchHeroDetailUseCaseProtocol {
    func execute(id: Int) async throws -> Hero
}

struct FetchHeroDetailUseCase: FetchHeroDetailUseCaseProtocol {
    private let repository: HeroRepositoryProtocol

    init(repository: HeroRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> Hero {
        try await repository.fetchHeroDetail(id: id)
    }
}
