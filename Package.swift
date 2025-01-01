// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ProgressSpinnerKit",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .library(name: "ProgressSpinnerKit", targets: ["ProgressSpinnerKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-tools-support-core.git", from: "0.7.0")
  ],
  targets: [
    .target(
      name: "ProgressSpinnerKit",
      dependencies: [
        .product(
          name: "SwiftToolsSupport",
          package: "swift-tools-support-core"
        )
      ]
    ),
    .testTarget(
      name: "ProgressSpinnerKitTests",
      dependencies: ["ProgressSpinnerKit"]
    ),
    .executableTarget(
      name: "demo",
      dependencies: ["ProgressSpinnerKit"]
    ),
  ]
)
