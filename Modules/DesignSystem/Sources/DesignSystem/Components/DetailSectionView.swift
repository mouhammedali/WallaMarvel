import SwiftUI

public struct DetailSectionView: View {
    let title: String
    let icon: String
    let items: [String]

    public init(title: String, icon: String, items: [String]) {
        self.title = title
        self.icon = icon
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Label(title, systemImage: icon)
                .font(DSTextStyles.title3)
                .accessibilityAddTraits(.isHeader)

            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: DSSpacing.sm) {
                    Image(systemName: DSSFIcon.bulletPoint)
                        .font(.system(size: DSSizes.Icon.bullet))
                        .foregroundStyle(DSColors.Text.secondary)
                        .padding(.top, 7)
                        .accessibilityHidden(true)

                    Text(item)
                        .font(DSTextStyles.subheadline)
                        .foregroundStyle(DSColors.Text.primary)
                }
            }
        }
        .accessibilityElement(children: .contain)
    }
}
