// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "Data", targets: ["Data"])
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(path: "../Domain"),
        .package(path: "../TestHelpers")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: ["Networking", "Domain"]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data", "Domain", "Networking", "TestHelpers"]
        )
    ]
)
