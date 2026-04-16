import Foundation
import Domain

public enum TestData {
    public static func makeHero(
        id: Int = 1,
        name: String = "Spider-Man",
        fullName: String = "Peter Parker",
        publisher: String = "Marvel Comics",
        alignment: String = "Good",
        powerstats: PowerStats = PowerStats(
            intelligence: 90,
            strength: 55,
            speed: 67,
            durability: 75,
            power: 74,
            combat: 85
        ),
        firstAppearance: String = "Amazing Fantasy #15",
        aliases: [String] = ["Spidey", "Web-Slinger"],
        groupAffiliation: String = "Avengers"
    ) -> Hero {
        Hero(
            id: id,
            name: name,
            fullName: fullName,
            thumbnailURL: URL(string: "https://example.com/thumb.jpg"),
            largeImageURL: URL(string: "https://example.com/large.jpg"),
            publisher: publisher,
            alignment: alignment,
            powerstats: powerstats,
            firstAppearance: firstAppearance,
            aliases: aliases,
            groupAffiliation: groupAffiliation
        )
    }

    public static func makeHeroesPage(
        heroes: [Hero]? = nil,
        offset: Int = 0,
        total: Int = 100
    ) -> HeroesPage {
        HeroesPage(
            heroes: heroes ?? [makeHero()],
            offset: offset,
            total: total
        )
    }
}
