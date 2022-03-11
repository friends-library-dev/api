import Foundation

enum Scope: String, Codable, CaseIterable, Equatable {
  case all
  case queryDownloads
  case mutateDownloads
  case queryOrders
  case mutateOrders
  case queryArtifactProductionVersions
  case mutateArtifactProductionVersions
  case queryEntities
  case mutateEntities
  case queryTokens
  case mutateTokens
}

final class TokenScope: Codable {
  var id: Id
  var scope: Scope
  var tokenId: Token.Id
  var createdAt = Current.date()

  var token = Parent<Token>.notLoaded

  var isValid: Bool { true }

  init(id: Id = .init(), tokenId: Token.Id, scope: Scope) {
    self.id = id
    self.scope = scope
    self.tokenId = tokenId
  }
}

// extensions

extension Scope: PostgresEnum {
  var dataType: String { TokenScope.M5.dbEnumName }
}
