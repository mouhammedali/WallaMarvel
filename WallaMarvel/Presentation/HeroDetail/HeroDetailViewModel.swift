import Foundation

@MainActor
final class HeroDetailViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded(Hero)
        case error(String)
    }

    @Published private(set) var state: ViewState = .idle

    let heroName: String
    private let heroId: Int
    private let fetchHeroDetailUseCase: any FetchHeroDetailUseCaseProtocol

    init(
        heroId: Int,
        heroName: String,
        fetchHeroDetailUseCase: any FetchHeroDetailUseCaseProtocol
    ) {
        self.heroId = heroId
        self.heroName = heroName
        self.fetchHeroDetailUseCase = fetchHeroDetailUseCase
    }

    func onAppear() async {
        guard state == .idle else { return }
        state = .loading
        await load()
    }

    func retry() async {
        state = .loading
        await load()
    }

    private func load() async {
        do {
            let hero = try await fetchHeroDetailUseCase.execute(id: heroId)
            state = .loaded(hero)
        } catch let apiError as APIError {
            state = .error(apiError.userMessage)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
