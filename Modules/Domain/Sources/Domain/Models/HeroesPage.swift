import Foundation

public struct HeroesPage: Equatable, Sendable {
    public let heroes: [Hero]
    public let offset: Int
    public let total: Int

    public var hasMore: Bool { offset + heroes.count < total }

    public init(heroes: [Hero], offset: Int, total: Int) {
        self.heroes = heroes
        self.offset = offset
        self.total = total
    }
}
