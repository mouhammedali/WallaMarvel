import SwiftUI

// MARK: - Hero Navigation Transition Helpers
// These wrappers check #available at the call site so views don't need
// @available annotations. On iOS <18 the standard push transition is used.

extension View {
    @ViewBuilder
    func heroTransitionSource(id: some Hashable, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }

    @ViewBuilder
    func heroDetailTransition(sourceID: some Hashable, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.navigationTransition(.zoom(sourceID: sourceID, in: namespace))
        } else {
            self
        }
    }
}
