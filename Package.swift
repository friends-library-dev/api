// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "graphql-api",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(
      url: "https://github.com/vapor/vapor.git",
      from: "4.54.0"
    ),
    .package(
      url: "https://github.com/vapor/fluent.git",
      from: "4.4.0"
    ),
    .package(
      url: "https://github.com/vapor/fluent-postgres-driver.git",
      from: "2.2.2"
    ),
    .package(
      name: "GraphQLKit",
      url: "https://github.com/alexsteinerde/graphql-kit.git",
      from: "2.3.0"
    ),
    .package(
      name: "VaporUtils",
      url: "https://github.com/jaredh159/vapor-utils.git",
      from: "3.0.0"
    ),
    .package(
      name: "QueuesFluentDriver",
      url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git",
      from: "1.2.0"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-tagged",
      from: "0.6.0"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-nonempty.git",
      from: "0.3.0"
    ),
    .package(
      url: "https://github.com/kylehughes/RomanNumeralKit.git",
      from: "1.0.0"
    ),
    .package(
      url: "https://github.com/JohnSundell/ShellOut.git",
      from: "2.0.0"
    ),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        .product(name: "Vapor", package: "vapor"),
        .product(name: "Tagged", package: "swift-tagged"),
        .product(name: "TaggedTime", package: "swift-tagged"),
        .product(name: "TaggedMoney", package: "swift-tagged"),
        .product(name: "NonEmpty", package: "swift-nonempty"),
        "RomanNumeralKit",
        "GraphQLKit",
        "QueuesFluentDriver",
        "VaporUtils",
        "ShellOut",
      ],
      swiftSettings: [
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
      ]
    ),
    .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
    .testTarget(
      name: "AppTests",
      dependencies: [
        .target(name: "App"),
        .product(name: "XCTVapor", package: "vapor"),
        .product(name: "XCTVaporUtils", package: "VaporUtils"),
      ]
    ),
  ]
)
