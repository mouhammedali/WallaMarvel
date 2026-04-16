import SwiftUI
import SnapshotTesting
import XCTest

enum SnapshotConfig {
    static let defaultWidth: CGFloat = 390
    static let defaultComponentHeight: CGFloat = 80
    static let defaultViewHeight: CGFloat = 400
}

@MainActor
func assertComponentSnapshot(
    _ view: some View,
    named name: String? = nil,
    width: CGFloat = SnapshotConfig.defaultWidth,
    height: CGFloat = SnapshotConfig.defaultComponentHeight,
    record isRecording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let hostView = view
        .frame(width: width, height: height)
        .background(Color.white)
        .environment(\.colorScheme, .light)
        .environment(\.sizeCategory, .medium)

    #if os(iOS)
    assertSnapshot(
        of: hostView,
        as: .image(layout: .fixed(width: width, height: height)),
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
    record isRecording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let hostView = view
        .frame(width: width, height: height)
        .background(Color.white)
        .environment(\.colorScheme, .light)
        .environment(\.sizeCategory, .medium)

    #if os(iOS)
    assertSnapshot(
        of: hostView,
        as: .image(layout: .fixed(width: width, height: height)),
        named: name,
        record: isRecording,
        file: file,
        testName: testName,
        line: line
    )
    #endif
}
