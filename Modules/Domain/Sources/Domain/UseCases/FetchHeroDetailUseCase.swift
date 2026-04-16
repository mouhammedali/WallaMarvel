import Foundation

public protocol FetchHeroDetailUseCaseProtocol {
    func execute(id: Int) async throws -> Hero
}

public struct FetchHeroDetailUseCase: FetchHeroDetailUseCaseProtocol {
    private let repository: HeroRepositoryProtocol

    public init(repository: HeroRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: Int) async throws -> Hero {
        try await repository.fetchHeroDetail(id: id)
    }
}
