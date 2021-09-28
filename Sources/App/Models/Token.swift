import Fluent
import Vapor

final class Token: Model, Content {
  static let schema = M4.tableName

  @ID(key: .id)
  var id: UUID?

  @Field(key: M4.value)
  var value: UUID

  @Field(key: M4.description)
  var description: String

  @Timestamp(key: FieldKey.createdAt, on: .create)
  var createdAt: Date?

  @Children(for: \TokenScope.$token)
  var scopes: [TokenScope]

  init() {}

  init(
    id: UUID? = nil,
    value: UUID? = nil,
    description: String,
    createdAt: Date? = nil
  ) {
    self.id = id
    self.value = value ?? UUID()
    self.description = description
    self.createdAt = createdAt ?? Date()
  }
}

extension Token {
  enum M4 {
    static let tableName = "tokens"
    static let value = FieldKey("value")
    static let description = FieldKey("description")
  }
}
