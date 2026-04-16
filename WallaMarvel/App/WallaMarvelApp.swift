import SwiftUI

@main
struct WallaMarvelApp: App {
    private let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
