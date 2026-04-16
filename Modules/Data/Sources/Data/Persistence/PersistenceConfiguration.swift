import Foundation
import SwiftData

public enum PersistenceConfiguration {
    public static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        if !inMemory {
            // Ensure Application Support directory exists before SwiftData/CoreData
            // attempts to create the store file — avoids noisy recovery logs on first launch.
            let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            if let appSupport, !FileManager.default.fileExists(atPath: appSupport.path) {
                try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
            }
        }
        let schema = Schema([HeroEntity.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
