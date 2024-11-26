// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "TransportHome",
            targets: ["TransportHome"]
        ),
        .library(
            name: "TransportHomeImp",
            targets: ["TransportHomeImp"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"),
        .package(path: "../Finance"),
        .package(path: "../Platform")
    ],
    targets: [
        .target(
            name: "TransportHome",
            dependencies: [
                "ModernRIBs",
            ]
        ),
        .target(
            name: "TransportHomeImp",
            dependencies: [
                "ModernRIBs",
                "TransportHome",
                .product(name: "FinanceRepository", package: "Finance"),
                .product(name: "Topup", package: "Finance"),
                .product(name: "SuperUI", package: "Platform"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ],
    swiftLanguageVersions: [
        .version("5.4")
    ]
)
