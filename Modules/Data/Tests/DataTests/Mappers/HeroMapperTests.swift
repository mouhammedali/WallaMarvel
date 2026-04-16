import XCTest
import Domain
@testable import Data

final class HeroMapperTests: XCTestCase {

    func test_map_setsAllFields() {
        let dto = TestDTOData.makeSuperheroDTO(id: 1, name: "Spider-Man")

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.id, 1)
        XCTAssertEqual(hero.name, "Spider-Man")
        XCTAssertEqual(hero.fullName, "Peter Parker")
        XCTAssertEqual(hero.publisher, "Marvel Comics")
    }

    func test_map_capitalizesAlignment() {
        let dto = TestDTOData.makeSuperheroDTO()

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.alignment, "Good")
    }

    func test_map_setsPowerStats() {
        let dto = TestDTOData.makeSuperheroDTO()

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.powerstats.intelligence, 90)
        XCTAssertEqual(hero.powerstats.strength, 55)
        XCTAssertEqual(hero.powerstats.speed, 67)
    }

    func test_map_transformsImageURLs() {
        let dto = TestDTOData.makeSuperheroDTO()

        let hero = HeroMapper.map(dto)

        XCTAssertEqual(hero.thumbnailURL?.absoluteString, "https://example.com/md.jpg")
        XCTAssertEqual(hero.largeImageURL?.absoluteString, "https://example.com/lg.jpg")
    }

    func test_map_filtersDashFromAliases() {
        // The default DTO doesn't have "-" but we verify the filter is present
        let dto = TestDTOData.makeSuperheroDTO()

        let hero = HeroMapper.map(dto)

        XCTAssertFalse(hero.aliases.contains("-"))
        XCTAssertEqual(hero.aliases, ["Spidey", "Web-Slinger"])
    }
}
