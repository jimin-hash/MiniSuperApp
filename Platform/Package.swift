// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "CombineUtil",
            targets: ["CombineUtil"]
        ),
        .library(
            name: "RIBsUtil",
            targets: ["RIBsUtil"]
        ),
        .library(
            name: "SuperUI",
            targets: ["SuperUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0"),
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "CombineUtil",
            dependencies: [
                "CombineExt"
            ]
        ),
        .target(
            name: "RIBsUtil",
            dependencies: [
                "ModernRIBs"
            ]
        ),
        .target(
            name: "SuperUI",
            dependencies: [
                "RIBsUtil"
            ]
        ),
    ],
    swiftLanguageVersions: [
        .version("5.4")
    ]
)
