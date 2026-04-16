import Foundation

enum HeroMapper {
    static func map(_ dto: SuperheroDTO) -> Hero {
        Hero(
            id: dto.id,
            name: dto.name,
            fullName: dto.biography.fullName,
            thumbnailURL: URL(string: dto.images.md),
            largeImageURL: URL(string: dto.images.lg),
            publisher: dto.biography.publisher ?? "Unknown",
            alignment: dto.biography.alignment.capitalized,
            powerstats: PowerStats(
                intelligence: dto.powerstats.intelligence,
                strength: dto.powerstats.strength,
                speed: dto.powerstats.speed,
                durability: dto.powerstats.durability,
                power: dto.powerstats.power,
                combat: dto.powerstats.combat
            ),
            firstAppearance: dto.biography.firstAppearance,
            aliases: dto.biography.aliases.filter { $0 != "-" },
            groupAffiliation: dto.connections.groupAffiliation
        )
    }
}
