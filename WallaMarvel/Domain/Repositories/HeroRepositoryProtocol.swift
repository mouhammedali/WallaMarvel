import Foundation

protocol HeroRepositoryProtocol {
    func fetchHeroes(offset: Int, limit: Int) async throws -> HeroesPage
    func searchHeroes(query: String, offset: Int, limit: Int) async throws -> HeroesPage
    func fetchHeroDetail(id: Int) async throws -> Hero
}
