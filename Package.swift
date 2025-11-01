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
        .package(url: "https://github.com/swiftlang/swift-markdown", from: "0.7.3"),
        .package(url: "https://github.com/divadretlaw/highlight.js", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "MarkdownUI",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "HighlightUI", package: "Highlight.js", condition: .when(platforms: [.iOS, .macOS, .tvOS, .visionOS]))
            ]
        )
    ]
)
