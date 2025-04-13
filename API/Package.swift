// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "API",
  platforms: [
    .macOS(.v10_14),
  ],
  products: [
    .library(name: "API", targets: ["API"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", exact: "1.19.0"),
  ],
  targets: [
    .target(
      name: "API",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
  ]
)
