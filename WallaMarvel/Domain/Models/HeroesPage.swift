import Foundation

struct HeroesPage: Equatable, Sendable {
    let heroes: [Hero]
    let offset: Int
    let total: Int

    var hasMore: Bool { offset + heroes.count < total }
}
