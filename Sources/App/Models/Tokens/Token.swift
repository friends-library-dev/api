import Fluent
import Tagged
import Vapor

final class Token {
  var id: Id
  var value: Value
  var description: String
  var createdAt = Current.date()

  var scopes = Children<TokenScope>.notLoaded

  init(id: Id = .init(), value: Value = .init(), description: String) {
    self.id = id
    self.value = value
    self.description = description
  }
}

/// extensions

extension Token: AppModel {
  typealias Id = Tagged<(Token, id: ()), UUID>
  typealias Value = Tagged<(Token, value: ()), UUID>
}

extension Token: DuetModel {
  static let tableName = "tokens"
}

extension Token: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case value
    case description
    case createdAt
  }
}

extension Token {
  enum M4 {
    static let tableName = "tokens"
    static let value = FieldKey("value")
    static let description = FieldKey("description")
  }
}