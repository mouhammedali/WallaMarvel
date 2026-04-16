import SwiftUI
import Domain
import Kingfisher

public struct HeroRowView: View {
    let hero: Hero

    public init(hero: Hero) {
        self.hero = hero
    }

    public var body: some View {
        HStack(spacing: DSSpacing.md) {
            heroImage
            heroInfo
        }
        .padding(.vertical, DSSpacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(hero.name), \(hero.publisher)")
        .accessibilityHint("Tap to view details")
    }

    private var heroImage: some View {
        KFImage(hero.thumbnailURL)
            .resizable()
            .placeholder {
                Image(systemName: DSSFIcon.personPlaceholder)
                    .resizable()
                    .foregroundStyle(DSColors.Text.secondary)
            }
            .fade(duration: 0.25)
            .scaledToFill()
            .frame(width: DSSizes.Avatar.medium, height: DSSizes.Avatar.medium)
            .clipShape(Circle())
            .accessibilityHidden(true)
    }

    private var heroInfo: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(hero.name)
                .font(DSTextStyles.headline)
                .foregroundStyle(DSColors.Text.primary)

            HStack(spacing: 6) {
                if hero.publisher != "Unknown" && !hero.publisher.isEmpty {
                    Text(hero.publisher)
                        .font(DSTextStyles.caption)
                        .foregroundStyle(DSColors.Text.secondary)
                }

                if hero.alignment != "-" && !hero.alignment.isEmpty {
                    Text("\u{00B7}")
                        .foregroundStyle(DSColors.Text.secondary)
                    Text(hero.alignment)
                        .font(DSTextStyles.caption)
                        .foregroundStyle(DSColors.alignment(hero.alignment))
                }
            }
        }
    }
}
