import SwiftUI
import Domain
import DesignSystem

struct HeroesListView: View {
    @StateObject private var viewModel: HeroesListViewModel
    var namespace: Namespace.ID

    init(viewModel: @autoclosure @escaping () -> HeroesListViewModel, namespace: Namespace.ID) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.namespace = namespace
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                loadingView
            case .loaded:
                heroList
            case .error(let message):
                ErrorStateView(message: message) {
                    Task { await viewModel.retry() }
                }
            }
        }
        .navigationTitle("Marvel Heroes")
        .searchable(text: $viewModel.searchText, prompt: "Search heroes by name")
        .onChange(of: viewModel.searchText) {
            viewModel.onSearchChanged()
        }
        .task {
            await viewModel.onAppear()
        }
        .accessibilityIdentifier("heroes_list_screen")
    }

    private var loadingView: some View {
        VStack(spacing: DSSpacing.lg) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading heroes...")
                .font(DSTextStyles.subheadline)
                .foregroundStyle(DSColors.Text.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var heroList: some View {
        List {
            ForEach(viewModel.heroes) { hero in
                NavigationLink(value: hero) {
                    HeroRowView(hero: hero)
                }
                .heroTransitionSource(id: hero.id, in: namespace)
                .onAppear {
                    if hero.id == viewModel.heroes.last?.id {
                        Task { await viewModel.loadNextPage() }
                    }
                }
                .accessibilityIdentifier("hero_row_\(hero.id)")
            }

            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.vertical, DSSpacing.sm)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .accessibilityLabel("Loading more heroes")
            }

            if viewModel.heroes.isEmpty {
                emptyStateView
            }
        }
        .listStyle(.plain)
        .animation(.default, value: viewModel.heroes.map(\.id))
        .accessibilityIdentifier("heroes_list")
    }

    private var emptyStateView: some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: DSSFIcon.magnifyingGlass)
                .font(.system(size: 40))
                .foregroundStyle(DSColors.Text.secondary)
            Text("No heroes found")
                .font(DSTextStyles.headline)
            if !viewModel.searchText.isEmpty {
                Text("Try a different search term")
                    .font(DSTextStyles.subheadline)
                    .foregroundStyle(DSColors.Text.secondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .listRowSeparator(.hidden)
        .accessibilityElement(children: .combine)
    }
}
