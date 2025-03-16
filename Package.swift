// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarkdownUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "MarkdownUI",
            targets: ["MarkdownUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-markdown", from: "0.5.0"),
        .package(url: "https://github.com/kean/Nuke", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "MarkdownUI",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "Nuke", package: "Nuke")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)] // Required for Nuke
        )
    ]
)
