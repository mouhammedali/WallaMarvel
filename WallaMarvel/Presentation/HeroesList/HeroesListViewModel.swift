import Foundation
import Combine

/// Drives the heroes list screen. Manages loading, pagination, and debounced search.
/// Marked @MainActor because all @Published state mutations must happen on the main thread.
@MainActor
final class HeroesListViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    @Published private(set) var heroes: [Hero] = []
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var isLoadingMore = false
    @Published var searchText = ""

    private let fetchHeroesUseCase: any FetchHeroesUseCaseProtocol
    private let searchHeroesUseCase: any SearchHeroesUseCaseProtocol
    private let pageSize = 20
    private var totalHeroes = 0
    private var searchTask: Task<Void, Never>?

    var hasMorePages: Bool {
        heroes.count < totalHeroes
    }

    init(
        fetchHeroesUseCase: any FetchHeroesUseCaseProtocol,
        searchHeroesUseCase: any SearchHeroesUseCaseProtocol
    ) {
        self.fetchHeroesUseCase = fetchHeroesUseCase
        self.searchHeroesUseCase = searchHeroesUseCase
    }

    func onAppear() async {
        guard state == .idle else { return }
        state = .loading
        await fetchPage(reset: true)
    }

    func loadNextPage() async {
        guard !isLoadingMore, hasMorePages, state == .loaded else { return }
        isLoadingMore = true
        await fetchPage(reset: false)
        isLoadingMore = false
    }

    func onSearchChanged() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            // Debounce 300ms to avoid excessive API calls while typing
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            self.state = .loading
            self.heroes = []
            await self.fetchPage(reset: true)
        }
    }

    func retry() async {
        state = .loading
        heroes = []
        await fetchPage(reset: true)
    }

    private func fetchPage(reset: Bool) async {
        do {
            let offset = reset ? 0 : heroes.count
            let page: HeroesPage

            if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                page = try await fetchHeroesUseCase.execute(offset: offset, limit: pageSize)
            } else {
                page = try await searchHeroesUseCase.execute(
                    query: searchText.trimmingCharacters(in: .whitespaces),
                    offset: offset,
                    limit: pageSize
                )
            }

            guard !Task.isCancelled else { return }

            if reset {
                heroes = page.heroes
            } else {
                heroes.append(contentsOf: page.heroes)
            }
            totalHeroes = page.total
            state = .loaded
        } catch is CancellationError {
            return
        } catch let apiError as APIError {
            if heroes.isEmpty {
                state = .error(apiError.userMessage)
            }
        } catch {
            if heroes.isEmpty {
                state = .error(error.localizedDescription)
            }
        }
    }
}
