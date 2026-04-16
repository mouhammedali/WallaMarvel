import SwiftUI
import SnapshotTesting
import XCTest

enum SnapshotConfig {
    static let defaultWidth: CGFloat = 390
    static let defaultComponentHeight: CGFloat = 80
    static let defaultViewHeight: CGFloat = 400
    static let isRecording: Bool = ProcessInfo.processInfo.environment["SNAPSHOT_RECORD"] == "1"
    /// Allow 2% pixel difference to handle cross-environment rendering (local vs CI).
    static let precision: Float = 0.98
}

@MainActor
func assertComponentSnapshot(
    _ view: some View,
    named name: String? = nil,
    width: CGFloat = SnapshotConfig.defaultWidth,
    height: CGFloat = SnapshotConfig.defaultComponentHeight,
    record isRecording: Bool = SnapshotConfig.isRecording,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let hostView = view
        .frame(width: width, height: height)
        .background(Color.white)
        .tint(.blue)
        .environment(\.colorScheme, .light)
        .environment(\.sizeCategory, .medium)
        .transaction { $0.disablesAnimations = true }

    #if os(iOS)
    assertSnapshot(
        of: hostView,
        as: .image(precision: SnapshotConfig.precision, layout: .fixed(width: width, height: height)),
        named: name,
        record: isRecording,
        file: file,
        testName: testName,
        line: line
    )
    #endif
}

@MainActor
func assertViewSnapshot(
    _ view: some View,
    named name: String? = nil,
    width: CGFloat = SnapshotConfig.defaultWidth,
    height: CGFloat = SnapshotConfig.defaultViewHeight,
    record isRecording: Bool = SnapshotConfig.isRecording,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let hostView = view
        .frame(width: width, height: height)
        .background(Color.white)
        .tint(.blue)
        .environment(\.colorScheme, .light)
        .environment(\.sizeCategory, .medium)
        .transaction { $0.disablesAnimations = true }

    #if os(iOS)
    assertSnapshot(
        of: hostView,
        as: .image(precision: SnapshotConfig.precision, layout: .fixed(width: width, height: height)),
        named: name,
        record: isRecording,
        file: file,
        testName: testName,
        line: line
    )
    #endif
}
