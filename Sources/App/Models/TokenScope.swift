import Fluent
import Vapor

enum Scope: String, Codable, CaseIterable, Equatable {
  case queryDownloads
  case mutateDownloads
  case queryOrders
  case mutateOrders
  case mutateArtifactProductionVersions
}

final class TokenScope: Model, Content {
  static let schema = M5.tableName

  @ID(key: .id)
  var id: UUID?

  @Enum(key: M5.scope)
  var scope: Scope

  @Parent(key: M5.tokenId)
  var token: Token

  @Timestamp(key: FieldKey.createdAt, on: .create)
  var createdAt: Date?

  init() {}

  init(id: UUID? = nil, tokenId: UUID? = nil, scope: Scope, createdAt: Date? = nil) {
    self.id = id
    self.scope = scope
    self.createdAt = createdAt ?? Date()
    if let tokenId = tokenId {
      self.$token.id = tokenId
    }
  }
}

extension TokenScope {
  enum M5 {
    static let tableName = "token_scopes"
    static let dbEnumName = "scopes"
    static let scope = FieldKey("scope")
    static let tokenId = FieldKey("token_id")
    enum Scope {
      static let queryDownloads = "queryDownloads"
      static let mutateDownloads = "mutateDownloads"
      static let queryOrders = "queryOrders"
      static let mutateOrders = "mutateOrders"
    }
  }

  enum M9 {
    enum Scope {
      static let mutateArtifactProductionVersions = "mutateArtifactProductionVersions"
    }
  }
}
