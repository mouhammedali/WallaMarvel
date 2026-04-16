import SwiftUI

public struct StaggeredAppearance: ViewModifier {
    let index: Int
    @State private var appeared = false

    public init(index: Int) {
        self.index = index
    }

    public func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
            .onAppear {
                withAnimation(
                    .easeOut(duration: 0.3)
                    .delay(Double(index) * 0.06)
                ) {
                    appeared = true
                }
            }
    }
}

extension View {
    public func staggeredAppearance(index: Int) -> some View {
        modifier(StaggeredAppearance(index: index))
    }
}
