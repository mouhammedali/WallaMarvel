import Foundation
import Domain

public enum HeroEntityMapper {
    public static func toDomain(_ entity: HeroEntity) -> Hero {
        let aliases: [String]
        if let json = entity.aliasesJSON,
           let data = json.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            aliases = decoded
        } else {
            aliases = []
        }

        return Hero(
            id: entity.heroId,
            name: entity.name,
            fullName: entity.fullName,
            thumbnailURL: entity.thumbnailURLString.flatMap(URL.init(string:)),
            largeImageURL: entity.largeImageURLString.flatMap(URL.init(string:)),
            publisher: entity.publisher,
            alignment: entity.alignment,
            powerstats: PowerStats(
                intelligence: entity.intelligence,
                strength: entity.strength,
                speed: entity.speed,
                durability: entity.durability,
                power: entity.power,
                combat: entity.combat
            ),
            firstAppearance: entity.firstAppearance,
            aliases: aliases,
            groupAffiliation: entity.groupAffiliation
        )
    }

    public static func toEntity(_ hero: Hero, sortIndex: Int) -> HeroEntity {
        let aliasesJSON: String?
        if let data = try? JSONEncoder().encode(hero.aliases) {
            aliasesJSON = String(data: data, encoding: .utf8)
        } else {
            aliasesJSON = nil
        }

        return HeroEntity(
            heroId: hero.id,
            name: hero.name,
            fullName: hero.fullName,
            thumbnailURLString: hero.thumbnailURL?.absoluteString,
            largeImageURLString: hero.largeImageURL?.absoluteString,
            publisher: hero.publisher,
            alignment: hero.alignment,
            intelligence: hero.powerstats.intelligence,
            strength: hero.powerstats.strength,
            speed: hero.powerstats.speed,
            durability: hero.powerstats.durability,
            power: hero.powerstats.power,
            combat: hero.powerstats.combat,
            firstAppearance: hero.firstAppearance,
            aliasesJSON: aliasesJSON,
            groupAffiliation: hero.groupAffiliation,
            sortIndex: sortIndex
        )
    }
}
