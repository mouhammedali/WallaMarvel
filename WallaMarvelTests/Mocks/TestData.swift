import Foundation
@testable import WallaMarvel

enum TestData {
    static func makeHero(
        id: Int = 1,
        name: String = "Spider-Man",
        fullName: String = "Peter Parker",
        publisher: String = "Marvel Comics",
        alignment: String = "Good"
    ) -> Hero {
        Hero(
            id: id,
            name: name,
            fullName: fullName,
            thumbnailURL: URL(string: "https://example.com/thumb.jpg"),
            largeImageURL: URL(string: "https://example.com/large.jpg"),
            publisher: publisher,
            alignment: alignment,
            powerstats: PowerStats(
                intelligence: 90,
                strength: 55,
                speed: 67,
                durability: 75,
                power: 74,
                combat: 85
            ),
            firstAppearance: "Amazing Fantasy #15",
            aliases: ["Spidey", "Web-Slinger"],
            groupAffiliation: "Avengers"
        )
    }

    static func makeHeroesPage(
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

    static func makeSuperheroDTO(
        id: Int = 1,
        name: String = "Spider-Man"
    ) -> SuperheroDTO {
        SuperheroDTO(
            id: id,
            name: name,
            slug: "\(id)-\(name.lowercased().replacingOccurrences(of: " ", with: "-"))",
            powerstats: PowerstatsDTO(
                intelligence: 90, strength: 55, speed: 67,
                durability: 75, power: 74, combat: 85
            ),
            appearance: AppearanceDTO(
                gender: "Male", race: "Human",
                height: ["5'10", "178 cm"], weight: ["165 lb", "75 kg"],
                eyeColor: "Hazel", hairColor: "Brown"
            ),
            biography: BiographyDTO(
                fullName: "Peter Parker",
                alterEgos: "No alter egos found.",
                aliases: ["Spidey", "Web-Slinger"],
                placeOfBirth: "New York",
                firstAppearance: "Amazing Fantasy #15",
                publisher: "Marvel Comics",
                alignment: "good"
            ),
            work: WorkDTO(
                occupation: "Photographer",
                base: "New York"
            ),
            connections: ConnectionsDTO(
                groupAffiliation: "Avengers",
                relatives: "May Parker (aunt)"
            ),
            images: ImagesDTO(
                xs: "https://example.com/xs.jpg",
                sm: "https://example.com/sm.jpg",
                md: "https://example.com/md.jpg",
                lg: "https://example.com/lg.jpg"
            )
        )
    }
}
