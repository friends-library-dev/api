import Fluent
import Vapor

struct CreateTokens: Migration {

  func prepare(on database: Database) -> Future<Void> {
    return database.schema(Token.M4.tableName)
      .id()
      .field(Token.M4.value, .uuid, .required)
      .field(Token.M4.description, .string, .required)
      .field(FieldKey.createdAt, .datetime, .required)
      .unique(on: Token.M4.value)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(Token.M4.tableName).delete()
  }
}
