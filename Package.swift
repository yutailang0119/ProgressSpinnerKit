// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProgressSpinnerKit",
    products: [
        .library(name: "ProgressSpinnerKit", targets: ["ProgressSpinnerKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core", from: "0.2.0"),
    ],
    targets: [
        .target(name: "ProgressSpinnerKit",
                dependencies: [
                    .product(name: "SwiftToolsSupport",
                             package: "swift-tools-support-core"),
                ]),
        .testTarget(name: "ProgressSpinnerKitTests",
                    dependencies: ["ProgressSpinnerKit"]),
        .target(name: "Demo",
                dependencies: ["ProgressSpinnerKit"]),
    ]
)
