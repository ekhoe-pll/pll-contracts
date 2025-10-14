// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ContractsKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ContractsKit",
            targets: ["ContractsKit"]
        ),
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .target(
            name: "ContractsKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "ContractsKitTests",
            dependencies: ["ContractsKit"],
            path: "Tests"
        ),
    ]
)
