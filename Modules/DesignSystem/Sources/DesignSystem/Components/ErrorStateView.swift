import SwiftUI

public struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    public init(message: String, retryAction: @escaping () -> Void) {
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: DSSpacing.lg) {
            Image(systemName: DSSFIcon.warning)
                .font(.system(size: DSSizes.Icon.error))
                .foregroundStyle(DSColors.Status.warning)
                .accessibilityHidden(true)

            Text("Something went wrong")
                .font(DSTextStyles.title3)

            Text(message)
                .font(DSTextStyles.body)
                .foregroundStyle(DSColors.Text.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DSSpacing.xxl)

            Button(action: retryAction) {
                Label("Retry", systemImage: DSSFIcon.retry)
                    .font(DSTextStyles.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, DSSpacing.md)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("retry_button")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .contain)
    }
}
