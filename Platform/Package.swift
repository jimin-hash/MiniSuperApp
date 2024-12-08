// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [
//        .iOS(.v14),
        .iOS(.v13)
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
            name: "RIBsTestSupport",
            targets: ["RIBsTestSupport"]
        ),
        .library(
            name: "SuperUI",
            targets: ["SuperUI"]
        ),
        .library(
            name: "DefaultsStore",
            targets: ["DefaultsStore"]
        ),
        .library(
            name: "Network",
            targets: ["Network"]
        ),
        .library(
            name: "NetworkImp",
            targets: ["NetworkImp"]
        ),
        .library(
            name: "PlatformTestSupport",
            targets: ["PlatformTestSupport"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0"),
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.3"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/lyft/Hammer.git", from: "0.13.0")
    ],
    targets: [
        .target(
            name: "CombineUtil",
            dependencies: [
                "CombineExt",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]
        ),
        .target(
            name: "RIBsTestSupport",
            dependencies: [
                "ModernRIBs"
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
        .target(
            name: "DefaultsStore",
            dependencies: [
            ]
        ),
        .target(
            name: "Network",
            dependencies: [
            ]
        ),
        .target(
            name: "NetworkImp",
            dependencies: [
                "Network"
            ]
        ),
        .target(
            name: "PlatformTestSupport",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Swifter", package: "swifter"),
                "Hammer"
            ]
        ),
    ],
    swiftLanguageVersions: [
        .version("5.4")
    ]
)
