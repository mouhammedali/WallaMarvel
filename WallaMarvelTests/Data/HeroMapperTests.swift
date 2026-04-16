import XCTest
@testable import WallaMarvel

final class HeroMapperTests: XCTestCase {

    func test_mapSuperheroDTO_mapsAllFields() {
        let dto = TestData.makeSuperheroDTO(id: 1, name: "Spider-Man")

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.id, 1)
        XCTAssertEqual(hero.name, "Spider-Man")
        XCTAssertEqual(hero.fullName, "Peter Parker")
        XCTAssertEqual(hero.publisher, "Marvel Comics")
        XCTAssertEqual(hero.alignment, "Good")
        XCTAssertEqual(hero.firstAppearance, "Amazing Fantasy #15")
        XCTAssertEqual(hero.aliases, ["Spidey", "Web-Slinger"])
        XCTAssertEqual(hero.groupAffiliation, "Avengers")
    }

    func test_mapSuperheroDTO_mapsPowerstats() {
        let dto = TestData.makeSuperheroDTO()

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.powerstats.intelligence, 90)
        XCTAssertEqual(hero.powerstats.strength, 55)
        XCTAssertEqual(hero.powerstats.speed, 67)
        XCTAssertEqual(hero.powerstats.durability, 75)
        XCTAssertEqual(hero.powerstats.power, 74)
        XCTAssertEqual(hero.powerstats.combat, 85)
    }

    func test_mapSuperheroDTO_mapsImageURLs() {
        let dto = TestData.makeSuperheroDTO()

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.thumbnailURL?.absoluteString, "https://example.com/md.jpg")
        XCTAssertEqual(hero.largeImageURL?.absoluteString, "https://example.com/lg.jpg")
    }

    func test_mapSuperheroDTO_filtersOutDashAliases() {
        var dto = TestData.makeSuperheroDTO()
        dto = SuperheroDTO(
            id: dto.id, name: dto.name, slug: dto.slug,
            powerstats: dto.powerstats, appearance: dto.appearance,
            biography: BiographyDTO(
                fullName: dto.biography.fullName,
                alterEgos: dto.biography.alterEgos,
                aliases: ["-", "Real Alias"],
                placeOfBirth: dto.biography.placeOfBirth,
                firstAppearance: dto.biography.firstAppearance,
                publisher: dto.biography.publisher,
                alignment: dto.biography.alignment
            ),
            work: dto.work, connections: dto.connections, images: dto.images
        )

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.aliases, ["Real Alias"])
    }

    func test_mapSuperheroDTO_handlesNilPublisher() {
        var dto = TestData.makeSuperheroDTO()
        dto = SuperheroDTO(
            id: dto.id, name: dto.name, slug: dto.slug,
            powerstats: dto.powerstats, appearance: dto.appearance,
            biography: BiographyDTO(
                fullName: dto.biography.fullName,
                alterEgos: dto.biography.alterEgos,
                aliases: dto.biography.aliases,
                placeOfBirth: dto.biography.placeOfBirth,
                firstAppearance: dto.biography.firstAppearance,
                publisher: nil,
                alignment: dto.biography.alignment
            ),
            work: dto.work, connections: dto.connections, images: dto.images
        )

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.publisher, "Unknown")
    }
}
