import Foundation
import Domain
import Networking

/// The Superhero API (akabab) returns all 731 heroes in a single JSON endpoint
/// rather than supporting server-side pagination. The repository fetches once,
/// caches in memory, and serves paginated slices and filtered search results
/// client-side. This gives instant pagination/search after the initial load.
public final class HeroRepository: HeroRepositoryProtocol {
    private let remoteDataSource: HeroRemoteDataSourceProtocol
    private let localDataSource: HeroLocalDataSourceProtocol?
    private let cache = HeroCache()

    public init(
        remoteDataSource: HeroRemoteDataSourceProtocol,
        localDataSource: HeroLocalDataSourceProtocol? = nil
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    public func fetchHeroes(offset: Int, limit: Int) async throws -> HeroesPage {
        let allHeroes = try await loadAllHeroes()
        return paginate(allHeroes, offset: offset, limit: limit)
    }

    public func searchHeroes(query: String, offset: Int, limit: Int) async throws -> HeroesPage {
        let allHeroes = try await loadAllHeroes()
        let filtered = allHeroes.filter { $0.name.localizedCaseInsensitiveContains(query) }
        return paginate(filtered, offset: offset, limit: limit)
    }

    public func fetchHeroDetail(id: Int) async throws -> Hero {
        let allHeroes = try await loadAllHeroes()
        guard let hero = allHeroes.first(where: { $0.id == id }) else {
            throw APIError.noData
        }
        return hero
    }

    // MARK: - Private

    private func loadAllHeroes() async throws -> [Hero] {
        // 1. In-memory cache (fastest)
        if let cached = await cache.heroes {
            return cached
        }

        // 2. Local persistence (SwiftData) — show cached data on restart
        if let local = localDataSource {
            let stored = try await local.fetchAllHeroes()
            if !stored.isEmpty {
                await cache.store(stored)
                // Background refresh
                Task { [weak self] in
                    try? await self?.refreshFromRemote()
                }
                return stored
            }
        }

        // 3. Remote fetch
        return try await loadFromRemote()
    }

    private func loadFromRemote() async throws -> [Hero] {
        let dtos = try await remoteDataSource.fetchAllHeroes()
        let heroes = dtos.map(HeroMapper.map)
        await cache.store(heroes)
        try? await localDataSource?.storeHeroes(heroes)
        return heroes
    }

    private func refreshFromRemote() async throws {
        let dtos = try await remoteDataSource.fetchAllHeroes()
        let heroes = dtos.map(HeroMapper.map)
        await cache.store(heroes)
        try? await localDataSource?.storeHeroes(heroes)
    }

    private func paginate(_ heroes: [Hero], offset: Int, limit: Int) -> HeroesPage {
        let clamped = min(offset, heroes.count)
        let page = Array(heroes.dropFirst(clamped).prefix(limit))
        return HeroesPage(heroes: page, offset: clamped, total: heroes.count)
    }
}

/// Thread-safe in-memory cache backed by a Swift actor.
private actor HeroCache {
    var heroes: [Hero]?

    func store(_ heroes: [Hero]) {
        self.heroes = heroes
    }
}
