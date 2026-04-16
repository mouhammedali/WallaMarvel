import SwiftUI
import Kingfisher
import Domain
import DesignSystem

struct HeroDetailView: View {
    @StateObject private var viewModel: HeroDetailViewModel
    var namespace: Namespace.ID
    let sourceHeroId: Int

    init(
        viewModel: @autoclosure @escaping () -> HeroDetailViewModel,
        namespace: Namespace.ID,
        sourceHeroId: Int
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.namespace = namespace
        self.sourceHeroId = sourceHeroId
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded(let hero):
                heroContent(hero)
            case .error(let message):
                ErrorStateView(message: message) {
                    Task { await viewModel.retry() }
                }
            }
        }
        .navigationTitle(viewModel.heroName)
        .navigationBarTitleDisplayMode(.inline)
        .heroDetailTransition(sourceID: sourceHeroId, in: namespace)
        .task {
            await viewModel.onAppear()
        }
        .accessibilityIdentifier("hero_detail_screen")
    }

    private func heroContent(_ hero: Hero) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                headerImage(hero)

                VStack(alignment: .leading, spacing: DSSpacing.xl) {
                    nameSection(hero)
                        .staggeredAppearance(index: 0)

                    publisherBadge(hero)
                        .staggeredAppearance(index: 1)

                    if hero.powerstats.intelligence > 0 || hero.powerstats.strength > 0 {
                        PowerStatsView(stats: hero.powerstats)
                            .staggeredAppearance(index: 2)
                    }

                    if !hero.firstAppearance.isEmpty && hero.firstAppearance != "-" {
                        DetailSectionView(
                            title: "First Appearance",
                            icon: DSSFIcon.book,
                            items: [hero.firstAppearance]
                        )
                        .staggeredAppearance(index: 3)
                    }

                    if !hero.aliases.isEmpty {
                        DetailSectionView(
                            title: "Aliases",
                            icon: DSSFIcon.person2,
                            items: hero.aliases
                        )
                        .staggeredAppearance(index: 4)
                    }

                    if !hero.groupAffiliation.isEmpty && hero.groupAffiliation != "-" {
                        DetailSectionView(
                            title: "Affiliations",
                            icon: DSSFIcon.person3,
                            items: hero.groupAffiliation
                                .components(separatedBy: "; ")
                                .map { $0.trimmingCharacters(in: .whitespaces) }
                                .filter { !$0.isEmpty }
                        )
                        .staggeredAppearance(index: 5)
                    }
                }
                .padding()
            }
        }
    }

    private func headerImage(_ hero: Hero) -> some View {
        KFImage(hero.largeImageURL)
            .resizable()
            .placeholder {
                Rectangle()
                    .fill(.secondary.opacity(0.2))
                    .overlay(
                        Image(systemName: DSSFIcon.personFill)
                            .font(.system(size: DSSizes.Icon.placeholder))
                            .foregroundStyle(DSColors.Text.secondary)
                    )
            }
            .fade(duration: 0.3)
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: DSSizes.HeroImage.headerHeight)
            .clipped()
            .accessibilityLabel("\(hero.name) portrait")
    }

    private func nameSection(_ hero: Hero) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(hero.name)
                .font(DSTextStyles.largeTitle)
                .accessibilityAddTraits(.isHeader)

            if !hero.fullName.isEmpty && hero.fullName != "-" && hero.fullName != hero.name {
                Text(hero.fullName)
                    .font(.title3)
                    .foregroundStyle(DSColors.Text.secondary)
            }
        }
    }

    private func publisherBadge(_ hero: Hero) -> some View {
        HStack(spacing: DSSpacing.sm) {
            if hero.publisher != "Unknown" && !hero.publisher.isEmpty {
                Text(hero.publisher)
                    .font(DSTextStyles.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, DSSizes.Badge.horizontalPadding)
                    .padding(.vertical, DSSizes.Badge.verticalPadding)
                    .background(DSColors.Publisher.badge.opacity(0.1))
                    .foregroundStyle(DSColors.Publisher.badge)
                    .clipShape(Capsule())
            }

            if hero.alignment != "-" && !hero.alignment.isEmpty {
                Text(hero.alignment)
                    .font(DSTextStyles.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, DSSizes.Badge.horizontalPadding)
                    .padding(.vertical, DSSizes.Badge.verticalPadding)
                    .background(DSColors.alignment(hero.alignment).opacity(0.1))
                    .foregroundStyle(DSColors.alignment(hero.alignment))
                    .clipShape(Capsule())
            }
        }
    }
}
