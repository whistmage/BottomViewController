// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BottomViewController",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "BottomViewController",
            targets: ["BottomViewController"]),
    ],
    targets: [
        .target(
            name: "BottomViewController",
            dependencies: [])
    ]
)
