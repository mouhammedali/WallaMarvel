import SwiftUI

struct PowerStatsView: View {
    let stats: PowerStats
    @State private var animateBars = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Power Stats", systemImage: "bolt.fill")
                .font(.title3)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 8) {
                StatBar(label: "Intelligence", value: stats.intelligence, color: .blue, animated: animateBars, delay: 0)
                StatBar(label: "Strength", value: stats.strength, color: .red, animated: animateBars, delay: 1)
                StatBar(label: "Speed", value: stats.speed, color: .green, animated: animateBars, delay: 2)
                StatBar(label: "Durability", value: stats.durability, color: .orange, animated: animateBars, delay: 3)
                StatBar(label: "Power", value: stats.power, color: .purple, animated: animateBars, delay: 4)
                StatBar(label: "Combat", value: stats.combat, color: .pink, animated: animateBars, delay: 5)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
                animateBars = true
            }
        }
    }
}

private struct StatBar: View {
    let label: String
    let value: Int
    let color: Color
    let animated: Bool
    let delay: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(value)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(value > 0 ? .primary : .secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.gradient)
                        .frame(width: geometry.size.width * currentFraction)
                        .animation(
                            .easeOut(duration: 0.4)
                            .delay(Double(delay) * 0.04),
                            value: animated
                        )
                }
            }
            .frame(height: 8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value) out of 100")
    }

    private var currentFraction: CGFloat {
        guard animated, value > 0 else { return 0 }
        return CGFloat(min(value, 100)) / 100.0
    }
}
