// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestContractsKit",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(name: "ContractsKit", path: "../")
    ],
    targets: [
        .executableTarget(
            name: "TestContractsKit",
            dependencies: ["ContractsKit"]
        )
    ]
)
