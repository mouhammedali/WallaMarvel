import XCTest
import SwiftUI
import SnapshotTesting
import Domain
import TestHelpers
@testable import DesignSystem

final class PowerStatsViewSnapshotTests: XCTestCase {

    @MainActor
    func test_powerStats_fullStats() {
        let stats = PowerStats(
            intelligence: 90, strength: 80, speed: 70,
            durability: 85, power: 95, combat: 60
        )
        let view = PowerStatsView(stats: stats)
        assertViewSnapshot(view, named: "full-stats", height: 280)
    }

    @MainActor
    func test_powerStats_zeroStats() {
        let stats = PowerStats(
            intelligence: 0, strength: 0, speed: 0,
            durability: 0, power: 0, combat: 0
        )
        let view = PowerStatsView(stats: stats)
        assertViewSnapshot(view, named: "zero-stats", height: 280)
    }

    @MainActor
    func test_powerStats_mixedStats() {
        let stats = PowerStats(
            intelligence: 100, strength: 10, speed: 50,
            durability: 0, power: 75, combat: 30
        )
        let view = PowerStatsView(stats: stats)
        assertViewSnapshot(view, named: "mixed-stats", height: 280)
    }
}
