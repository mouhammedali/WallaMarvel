import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystem

final class DetailSectionViewSnapshotTests: XCTestCase {

    @MainActor
    func test_detailSection_singleItem() {
        let view = DetailSectionView(
            title: "First Appearance",
            icon: "book.fill",
            items: ["Amazing Fantasy #15"]
        )
        assertViewSnapshot(view, named: "single-item", height: 100)
    }

    @MainActor
    func test_detailSection_multipleItems() {
        let view = DetailSectionView(
            title: "Aliases",
            icon: "person.2.fill",
            items: ["Spidey", "Web-Slinger", "Friendly Neighborhood Spider-Man", "The Amazing Spider-Man"]
        )
        assertViewSnapshot(view, named: "multiple-items", height: 200)
    }
}
