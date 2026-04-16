import SwiftUI
import Kingfisher

struct HeroRowView: View {
    let hero: Hero

    var body: some View {
        HStack(spacing: 12) {
            heroImage
            heroInfo
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(hero.name), \(hero.publisher)")
        .accessibilityHint("Tap to view details")
    }

    private var heroImage: some View {
        KFImage(hero.thumbnailURL)
            .resizable()
            .placeholder {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
            }
            .fade(duration: 0.25)
            .scaledToFill()
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            .accessibilityHidden(true)
    }

    private var heroInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(hero.name)
                .font(.headline)
                .foregroundStyle(.primary)

            HStack(spacing: 6) {
                if hero.publisher != "Unknown" && !hero.publisher.isEmpty {
                    Text(hero.publisher)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if hero.alignment != "-" && !hero.alignment.isEmpty {
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(hero.alignment)
                        .font(.caption)
                        .foregroundStyle(alignmentColor)
                }
            }
        }
    }

    private var alignmentColor: Color {
        switch hero.alignment.lowercased() {
        case "good": return .green
        case "bad": return .red
        case "neutral": return .orange
        default: return .secondary
        }
    }
}
