// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-music",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Music",
            targets: ["Music"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3")
    ],
    targets: [
        .target(name: "Music"),
        .testTarget(
            name: "MusicTests",
            dependencies: ["Music"]
        )
    ]
)
