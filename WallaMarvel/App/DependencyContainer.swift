import Foundation

/// Composition root — wires all dependencies using constructor injection.
/// Lazy properties ensure each dependency is created once and shared across
/// the object graph. No third-party DI framework needed for this scale.
final class DependencyContainer {

    // MARK: - Core

    private lazy var httpClient: HTTPClient = URLSessionHTTPClient()

    // MARK: - Data

    private lazy var remoteDataSource: HeroRemoteDataSourceProtocol = {
        SuperheroRemoteDataSource(httpClient: httpClient)
    }()

    private lazy var heroRepository: HeroRepositoryProtocol = {
        HeroRepository(remoteDataSource: remoteDataSource)
    }()

    // MARK: - ViewModels

    @MainActor
    func makeHeroesListViewModel() -> HeroesListViewModel {
        HeroesListViewModel(
            fetchHeroesUseCase: FetchHeroesUseCase(repository: heroRepository),
            searchHeroesUseCase: SearchHeroesUseCase(repository: heroRepository)
        )
    }

    @MainActor
    func makeHeroDetailViewModel(for hero: Hero) -> HeroDetailViewModel {
        HeroDetailViewModel(
            heroId: hero.id,
            heroName: hero.name,
            fetchHeroDetailUseCase: FetchHeroDetailUseCase(repository: heroRepository)
        )
    }
}
