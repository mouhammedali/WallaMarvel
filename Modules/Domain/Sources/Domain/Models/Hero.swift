import Foundation

public struct Hero: Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let thumbnailURL: URL?
    public let largeImageURL: URL?
    public let publisher: String
    public let alignment: String
    public let powerstats: PowerStats
    public let firstAppearance: String
    public let aliases: [String]
    public let groupAffiliation: String

    public init(
        id: Int,
        name: String,
        fullName: String,
        thumbnailURL: URL?,
        largeImageURL: URL?,
        publisher: String,
        alignment: String,
        powerstats: PowerStats,
        firstAppearance: String,
        aliases: [String],
        groupAffiliation: String
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.thumbnailURL = thumbnailURL
        self.largeImageURL = largeImageURL
        self.publisher = publisher
        self.alignment = alignment
        self.powerstats = powerstats
        self.firstAppearance = firstAppearance
        self.aliases = aliases
        self.groupAffiliation = groupAffiliation
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

public struct PowerStats: Hashable, Sendable {
    public let intelligence: Int
    public let strength: Int
    public let speed: Int
    public let durability: Int
    public let power: Int
    public let combat: Int

    public init(
        intelligence: Int,
        strength: Int,
        speed: Int,
        durability: Int,
        power: Int,
        combat: Int
    ) {
        self.intelligence = intelligence
        self.strength = strength
        self.speed = speed
        self.durability = durability
        self.power = power
        self.combat = combat
    }
}
