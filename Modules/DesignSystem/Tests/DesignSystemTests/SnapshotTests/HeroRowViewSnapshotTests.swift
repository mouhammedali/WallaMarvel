import XCTest
import SwiftUI
import SnapshotTesting
import Domain
import TestHelpers
@testable import DesignSystem

final class HeroRowViewSnapshotTests: XCTestCase {

    @MainActor
    func test_heroRow_normalHero() {
        let hero = TestData.makeHero(name: "Spider-Man", publisher: "Marvel Comics", alignment: "Good")
        let view = HeroRowView(hero: hero)
        assertComponentSnapshot(view, named: "normal")
    }

    @MainActor
    func test_heroRow_longName() {
        let hero = TestData.makeHero(
            name: "Professor Charles Francis Xavier",
            publisher: "Marvel Comics",
            alignment: "Good"
        )
        let view = HeroRowView(hero: hero)
        assertComponentSnapshot(view, named: "long-name")
    }

    @MainActor
    func test_heroRow_unknownPublisher() {
        let hero = TestData.makeHero(name: "Unknown Hero", publisher: "Unknown", alignment: "Neutral")
        let view = HeroRowView(hero: hero)
        assertComponentSnapshot(view, named: "unknown-publisher")
    }

    @MainActor
    func test_heroRow_badAlignment() {
        let hero = TestData.makeHero(name: "Joker", publisher: "DC Comics", alignment: "Bad")
        let view = HeroRowView(hero: hero)
        assertComponentSnapshot(view, named: "bad-alignment")
    }
}
