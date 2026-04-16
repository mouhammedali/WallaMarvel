// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestHelpers",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "TestHelpers", targets: ["TestHelpers"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(
            name: "TestHelpers",
            dependencies: ["Domain", "Networking"]
        )
    ]
)
