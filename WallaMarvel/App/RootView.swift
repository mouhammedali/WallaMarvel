import SwiftUI
import Domain
import DesignSystem

struct RootView: View {
    let container: DependencyContainer
    @Namespace private var heroTransition

    var body: some View {
        NavigationStack {
            HeroesListView(
                viewModel: container.makeHeroesListViewModel(),
                namespace: heroTransition
            )
            .navigationDestination(for: Hero.self) { hero in
                HeroDetailView(
                    viewModel: container.makeHeroDetailViewModel(for: hero),
                    namespace: heroTransition,
                    sourceHeroId: hero.id
                )
            }
        }
        .tint(.primary)
    }
}
