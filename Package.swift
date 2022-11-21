// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Turkey-To-Go",
  platforms: [
    .iOS("15.1"),
  ],
  products: [
    .library(
      name: "AppFeature",
      targets: [
        "AppFeature"
      ]
    ),
    .library(
      name: "DetailFeature",
      targets: [
        "DetailFeature"
      ]
    ),
    .library(
      name: "OpenAIClient",
      targets: [
        "OpenAIClient"
      ]
    ),
    .library(
      name: "SharedModels",
      targets: [
        "SharedModels"
      ]
    ),
    .library(
      name: "ShoppingFeature",
      targets: [
        "ShoppingFeature"
      ]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "0.46.0")
    )
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "AppFeatureTests",
      dependencies: [
        "AppFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "ShoppingFeature",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "ShoppingFeatureTests",
      dependencies: [
        "ShoppingFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "DetailFeature",
      dependencies: [
        "OpenAIClient",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "DetailFeatureTests",
      dependencies: [
        "DetailFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "OpenAIClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
  ]
)
