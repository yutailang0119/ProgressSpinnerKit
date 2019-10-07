// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProgressSpinnerKit",
    products: [
        .library(name: "ProgressSpinnerKit", targets: ["ProgressSpinnerKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0"),
    ],
    targets: [
        .target(name: "ProgressSpinnerKit", dependencies: ["SPMUtility"]),
        .testTarget(name: "ProgressSpinnerKitTests", dependencies: ["ProgressSpinnerKit"]),
        .target(name: "Demo", dependencies: ["ProgressSpinnerKit"]),
    ]
)
