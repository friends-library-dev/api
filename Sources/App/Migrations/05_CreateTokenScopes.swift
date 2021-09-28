import Fluent
import Vapor

struct CreateTokenScopes: Migration {

  func prepare(on database: Database) -> Future<Void> {
    return database.enum(TokenScope.M5.dbEnumName)
      .case(TokenScope.M5.Scope.queryDownloads)
      .case(TokenScope.M5.Scope.mutateDownloads)
      .case(TokenScope.M5.Scope.queryOrders)
      .case(TokenScope.M5.Scope.mutateOrders)
      .create()
      .flatMap { scopes in
        database.schema(TokenScope.M5.tableName)
          .id()
          .field(
            TokenScope.M5.tokenId,
            .uuid,
            .required,
            .references(Token.M4.tableName, "id", onDelete: .cascade)
          )
          .field(TokenScope.M5.scope, scopes, .required)
          .field(FieldKey.createdAt, .datetime, .required)
          .unique(on: TokenScope.M5.tokenId, TokenScope.M5.scope)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(TokenScope.M5.tableName).delete()
  }
}
