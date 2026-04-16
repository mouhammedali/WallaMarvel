import SwiftUI
import Domain

public struct PowerStatsView: View {
    let stats: PowerStats
    @State private var animateBars = false

    public init(stats: PowerStats) {
        self.stats = stats
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Label("Power Stats", systemImage: DSSFIcon.bolt)
                .font(DSTextStyles.title3)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: DSSpacing.sm) {
                statBar("Intelligence", stats.intelligence, DSColors.Stats.intelligence, 0)
                statBar("Strength", stats.strength, DSColors.Stats.strength, 1)
                statBar("Speed", stats.speed, DSColors.Stats.speed, 2)
                statBar("Durability", stats.durability, DSColors.Stats.durability, 3)
                statBar("Power", stats.power, DSColors.Stats.power, 4)
                statBar("Combat", stats.combat, DSColors.Stats.combat, 5)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
                animateBars = true
            }
        }
    }

    private func statBar(
        _ label: String, _ value: Int, _ color: Color, _ delay: Int
    ) -> StatBar {
        StatBar(label: label, value: value, color: color, animated: animateBars, delay: delay)
    }
}

private struct StatBar: View {
    let label: String
    let value: Int
    let color: Color
    let animated: Bool
    let delay: Int

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxs) {
            HStack {
                Text(label)
                    .font(DSTextStyles.caption)
                    .foregroundStyle(DSColors.Text.secondary)
                Spacer()
                Text("\(value)")
                    .font(DSTextStyles.captionBold)
                    .foregroundStyle(value > 0 ? DSColors.Text.primary : DSColors.Text.secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: DSCornerRadius.small)
                        .fill(DSColors.Background.statBar)

                    RoundedRectangle(cornerRadius: DSCornerRadius.small)
                        .fill(color.gradient)
                        .frame(width: geometry.size.width * currentFraction)
                        .animation(
                            .easeOut(duration: 0.4)
                            .delay(Double(delay) * 0.04),
                            value: animated
                        )
                }
            }
            .frame(height: DSSizes.StatBar.height)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value) out of 100")
    }

    private var currentFraction: CGFloat {
        guard animated, value > 0 else { return 0 }
        return CGFloat(min(value, 100)) / 100.0
    }
}
