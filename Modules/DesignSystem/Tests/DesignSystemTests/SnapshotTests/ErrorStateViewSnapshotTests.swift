import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystem

final class ErrorStateViewSnapshotTests: XCTestCase {

    @MainActor
    func test_errorState_shortMessage() {
        let view = ErrorStateView(message: "Network error") {}
        assertViewSnapshot(view, named: "short-message", height: 300)
    }

    @MainActor
    func test_errorState_longMessage() {
        let view = ErrorStateView(
            message: "Server error (code: 500). Please try again later."
        ) {}
        assertViewSnapshot(view, named: "long-message", height: 300)
    }
}
