// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CX",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "AppHome",
            targets: ["AppHome"]),
    ],
    dependencies: [
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"),
        .package(path: "../Finance"),
        .package(path: "../Transport"),
    ],
    targets: [
        .target(
            name: "AppHome",
            dependencies: [
                "ModernRIBs",
                .product(name: "FinanceRepository", package: "Finance"),
                .product(name: "TransportHome", package: "Transport"),
            ]
        ),
    ],
    swiftLanguageVersions: [
        .version("5.4")
    ]
)
