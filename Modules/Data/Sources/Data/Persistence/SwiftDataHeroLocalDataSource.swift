import Foundation
import SwiftData
import Domain

public final class SwiftDataHeroLocalDataSource: HeroLocalDataSourceProtocol, @unchecked Sendable {
    private let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    @MainActor
    public func fetchAllHeroes() async throws -> [Hero] {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<HeroEntity>(
            sortBy: [SortDescriptor(\.sortIndex)]
        )
        let entities = try context.fetch(descriptor)
        return entities.map(HeroEntityMapper.toDomain)
    }

    public func storeHeroes(_ heroes: [Hero]) async throws {
        let context = ModelContext(modelContainer)
        // Delete existing data before storing fresh data
        try context.delete(model: HeroEntity.self)

        for (index, hero) in heroes.enumerated() {
            let entity = HeroEntityMapper.toEntity(hero, sortIndex: index)
            context.insert(entity)
        }
        try context.save()
    }

    public func deleteAll() async throws {
        let context = ModelContext(modelContainer)
        try context.delete(model: HeroEntity.self)
        try context.save()
    }
}
