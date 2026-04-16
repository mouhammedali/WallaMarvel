import Foundation

struct Hero: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let fullName: String
    let thumbnailURL: URL?
    let largeImageURL: URL?
    let publisher: String
    let alignment: String
    let powerstats: PowerStats
    let firstAppearance: String
    let aliases: [String]
    let groupAffiliation: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

struct PowerStats: Hashable, Sendable {
    let intelligence: Int
    let strength: Int
    let speed: Int
    let durability: Int
    let power: Int
    let combat: Int
}
