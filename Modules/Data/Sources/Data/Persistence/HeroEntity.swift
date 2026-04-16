import Foundation
import SwiftData

@Model
public final class HeroEntity {
    @Attribute(.unique) public var heroId: Int
    public var name: String
    public var fullName: String
    public var thumbnailURLString: String?
    public var largeImageURLString: String?
    public var publisher: String
    public var alignment: String
    public var intelligence: Int
    public var strength: Int
    public var speed: Int
    public var durability: Int
    public var power: Int
    public var combat: Int
    public var firstAppearance: String
    public var aliasesJSON: String?
    public var groupAffiliation: String
    public var sortIndex: Int
    public var lastUpdated: Date

    public init(
        heroId: Int,
        name: String,
        fullName: String,
        thumbnailURLString: String?,
        largeImageURLString: String?,
        publisher: String,
        alignment: String,
        intelligence: Int,
        strength: Int,
        speed: Int,
        durability: Int,
        power: Int,
        combat: Int,
        firstAppearance: String,
        aliasesJSON: String?,
        groupAffiliation: String,
        sortIndex: Int,
        lastUpdated: Date = Date()
    ) {
        self.heroId = heroId
        self.name = name
        self.fullName = fullName
        self.thumbnailURLString = thumbnailURLString
        self.largeImageURLString = largeImageURLString
        self.publisher = publisher
        self.alignment = alignment
        self.intelligence = intelligence
        self.strength = strength
        self.speed = speed
        self.durability = durability
        self.power = power
        self.combat = combat
        self.firstAppearance = firstAppearance
        self.aliasesJSON = aliasesJSON
        self.groupAffiliation = groupAffiliation
        self.sortIndex = sortIndex
        self.lastUpdated = lastUpdated
    }
}
