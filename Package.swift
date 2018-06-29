// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rooster",
    products: [
        .library(name: "Rooster", targets: ["Rooster"]),
    ],
    dependencies: [
    .package(url: "https://github.com/xrisyz/Rooster", from: "0.1.1")
    ],
    targets: [
        .target(
            name: "Rooster",
            dependencies: []),
        .testTarget(
            name: "RoosterTests",
            dependencies: ["Rooster"]),
    ]
)
