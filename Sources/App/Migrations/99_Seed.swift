import Fluent
import Vapor

struct Seeded {
  struct Tokens {
    let queryDownloads = UUID(uuidString: "ECB4BC53-5F37-4D9D-BB3C-2256386FECD9")!
    let queryOrders = UUID(uuidString: "FCBF1F83-E771-4BA5-8DC3-137322793BE5")!
    let mutateDownloads = UUID(uuidString: "A957D4BC-F172-4A65-9E70-FFE06B5A1484")!
    let mutateOrders = UUID(uuidString: "3410A02F-156C-4EE4-8145-2D7EBCD4885E")!
    let mutateArtifactProductionVersions = UUID(uuidString: "C23BD372-AC46-4005-B612-78B23BCADEF9")!
    let allScopes = UUID(uuidString: "AB9E8FCA-BA51-4E7E-B5D1-00D9269503AE")!
  }

  static let tokens = Tokens()
}

struct Seed: Migration {

  func prepare(on database: Database) -> Future<Void> {
    let tokens: [UUID: (String, [Scope])] = [
      Seeded.tokens.queryDownloads: ("queryDownloads", [.queryDownloads]),
      Seeded.tokens.mutateDownloads: ("mutateDownloads", [.mutateDownloads]),
      Seeded.tokens.queryOrders: ("queryOrders", [.queryOrders]),
      Seeded.tokens.mutateOrders: ("mutateOrders", [.mutateOrders]),
      Seeded.tokens.mutateArtifactProductionVersions: (
        "mutateArtifactProductionVersions",
        [.mutateArtifactProductionVersions]
      ),
      Seeded.tokens.allScopes: (
        "allScopes",
        [
          .queryDownloads,
          .queryOrders,
          .mutateDownloads,
          .mutateOrders,
          .mutateArtifactProductionVersions,
        ]
      ),
    ]

    var futures: [Future<Void>] = []

    for (tokenValue, (description, scopes)) in tokens {
      let token = Token(value: tokenValue, description: description)
      let future = token.create(on: database).flatMap {
        scopes
          .map { TokenScope(tokenId: token.id!, scope: $0) }
          .create(on: database)
      }
      futures.append(future)
    }
    return futures.flatten(on: database.eventLoop)
  }

  func revert(on database: Database) -> Future<Void> {
    return database.eventLoop.makeSucceededVoidFuture()
  }
}
