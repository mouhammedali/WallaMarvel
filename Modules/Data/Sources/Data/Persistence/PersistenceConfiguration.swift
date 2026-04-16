import Foundation
import SwiftData

public enum PersistenceConfiguration {
    public static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([HeroEntity.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
