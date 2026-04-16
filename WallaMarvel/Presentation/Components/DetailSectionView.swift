import SwiftUI

struct DetailSectionView: View {
    let title: String
    let icon: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)

            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 5))
                        .foregroundStyle(.secondary)
                        .padding(.top, 7)
                        .accessibilityHidden(true)

                    Text(item)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }
        }
        .accessibilityElement(children: .contain)
    }
}
