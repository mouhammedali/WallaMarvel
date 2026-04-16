import XCTest
import Domain
@testable import Data

final class HeroEntityMapperTests: XCTestCase {

    func test_roundTrip_preservesAllFields() {
        let hero = Hero(
            id: 42,
            name: "Spider-Man",
            fullName: "Peter Parker",
            thumbnailURL: URL(string: "https://example.com/thumb.jpg"),
            largeImageURL: URL(string: "https://example.com/large.jpg"),
            publisher: "Marvel Comics",
            alignment: "Good",
            powerstats: PowerStats(
                intelligence: 90, strength: 55, speed: 67,
                durability: 75, power: 74, combat: 85
            ),
            firstAppearance: "Amazing Fantasy #15",
            aliases: ["Spidey", "Web-Slinger"],
            groupAffiliation: "Avengers"
        )

        let entity = HeroEntityMapper.toEntity(hero, sortIndex: 5)
        let result = HeroEntityMapper.toDomain(entity)

        XCTAssertEqual(result.id, hero.id)
        XCTAssertEqual(result.name, hero.name)
        XCTAssertEqual(result.fullName, hero.fullName)
        XCTAssertEqual(result.thumbnailURL, hero.thumbnailURL)
        XCTAssertEqual(result.largeImageURL, hero.largeImageURL)
        XCTAssertEqual(result.publisher, hero.publisher)
        XCTAssertEqual(result.alignment, hero.alignment)
        XCTAssertEqual(result.powerstats, hero.powerstats)
        XCTAssertEqual(result.firstAppearance, hero.firstAppearance)
        XCTAssertEqual(result.aliases, hero.aliases)
        XCTAssertEqual(result.groupAffiliation, hero.groupAffiliation)
    }

    func test_toEntity_setsSortIndex() {
        let hero = Hero(
            id: 1, name: "Test", fullName: "", thumbnailURL: nil,
            largeImageURL: nil, publisher: "", alignment: "",
            powerstats: PowerStats(intelligence: 0, strength: 0, speed: 0, durability: 0, power: 0, combat: 0),
            firstAppearance: "", aliases: [], groupAffiliation: ""
        )

        let entity = HeroEntityMapper.toEntity(hero, sortIndex: 7)

        XCTAssertEqual(entity.sortIndex, 7)
    }

    func test_toDomain_handlesNilAliasesJSON() {
        let entity = HeroEntity(
            heroId: 1, name: "Test", fullName: "",
            thumbnailURLString: nil, largeImageURLString: nil,
            publisher: "", alignment: "",
            intelligence: 0, strength: 0, speed: 0,
            durability: 0, power: 0, combat: 0,
            firstAppearance: "", aliasesJSON: nil,
            groupAffiliation: "", sortIndex: 0
        )

        let hero = HeroEntityMapper.toDomain(entity)

        XCTAssertEqual(hero.aliases, [])
    }
}
