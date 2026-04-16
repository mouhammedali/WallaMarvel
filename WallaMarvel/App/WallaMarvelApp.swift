import SwiftUI
import Data

@main
struct WallaMarvelApp: App {
    private let container: DependencyContainer

    init() {
        do {
            let modelContainer = try PersistenceConfiguration.makeContainer()
            container = DependencyContainer(modelContainer: modelContainer)
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
