// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "graphql-api",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    .package(
      url: "https://github.com/vapor/vapor.git",
      from: "4.48.3"
    ),
    .package(
      url: "https://github.com/vapor/fluent.git",
      from: "4.3.1"
    ),
    .package(
      url: "https://github.com/vapor/fluent-postgres-driver.git",
      from: "2.1.3"
    ),
    .package(
      name: "GraphQLKit",
      url: "https://github.com/alexsteinerde/graphql-kit.git",
      from: "2.3.0"
    ),
    .package(
      name: "VaporUtils",
      url: "https://github.com/jaredh159/vapor-utils.git",
      from: "2.1.0"
    ),
    .package(
      name: "QueuesFluentDriver",
      url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git",
      from: "1.2.0"
    ),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        .product(name: "Vapor", package: "vapor"),
        "GraphQLKit",
        "QueuesFluentDriver",
        "VaporUtils",
      ],
      swiftSettings: [
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
      ]
    ),
    .target(name: "Run", dependencies: [.target(name: "App")]),
    .testTarget(
      name: "AppTests",
      dependencies: [
        .target(name: "App"),
        .product(name: "XCTVapor", package: "vapor"),
        .product(name: "XCTVaporUtils", package: "VaporUtils"),
      ]),
  ]
)
