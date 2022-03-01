import Foundation

protocol PostgresEnum {
  var dataType: String { get }
  var rawValue: String { get }
}

enum Postgres {

  enum Columns {
    case all
    case columns([String])

    var sql: String {
      switch self {
        case .all:
          return "*"
        case .columns(let columns):
          return "\"\(columns.joined(separator: "\", \""))\""
      }
    }
  }

  enum WhereOperator {
    case equals

    var sql: String {
      switch self {
        case .equals:
          return "="
      }
    }
  }

  enum Data {
    case id(UUIDIdentifiable)
    case string(String?)
    case intArray([Int]?)
    case int(Int?)
    case int64(Int64?)
    case float(Float?)
    case double(Double?)
    case uuid(UUIDStringable?)
    case bool(Bool?)
    case date(Date?)
    case `enum`(PostgresEnum?)
    case json(String?)
    case null
    case currentTimestamp

    var holdsNull: Bool {
      switch self {
        case .id, .currentTimestamp, .null:
          return false
        case .string(let wrapped):
          return wrapped == nil
        case .intArray(let wrapped):
          return wrapped == nil
        case .int(let wrapped):
          return wrapped == nil
        case .int64(let wrapped):
          return wrapped == nil
        case .float(let wrapped):
          return wrapped == nil
        case .double(let wrapped):
          return wrapped == nil
        case .uuid(let wrapped):
          return wrapped == nil
        case .bool(let wrapped):
          return wrapped == nil
        case .date(let wrapped):
          return wrapped == nil
        case .enum(let wrapped):
          return wrapped == nil
        case .json(let wrapped):
          return wrapped == nil
      }
    }

    var typeName: String {
      switch self {
        case .string:
          return "text"
        case .int, .int64, .double, .float:
          return "numeric"
        case .intArray:
          return "numeric[]"
        case .uuid, .id:
          return "uuid"
        case .bool:
          return "bool"
        case .enum(let enumVal):
          return enumVal?.dataType ?? "unknown"
        case .null:
          return "unknown"
        case .date:
          return "timestamp"
        case .json:
          return "jsonb"
        case .currentTimestamp:
          return "timestamp"
      }
    }

    var param: String {
      switch self {
        case .enum(let enumVal):
          return nullable(enumVal?.rawValue)
        case .string(let string):
          return nullable(string)
        case .int64(let int64):
          return nullable(int64)
        case .int(let int):
          return nullable(int)
        case .float(let float):
          return nullable(float)
        case .double(let double):
          return nullable(double)
        case .intArray(let ints):
          guard let ints = ints else { return "NULL" }
          return "'{\(ints.map(String.init).joined(separator: ","))}'"
        case .id(let model):
          return "'\(model.uuidId.uuidString)'"
        case .uuid(let uuid):
          return nullable(uuid?.uuidString)
        case .bool(let bool):
          return nullable(bool)
        case .json(let string):
          return nullable(string)
        case .date(let date):
          return nullable(date)
        case .null:
          return "NULL"
        case .currentTimestamp:
          return "current_timestamp"
      }
    }
  }
}

private func nullable(_ string: String?) -> String {
  switch string {
    case nil:
      return "NULL"
    case .some(let string):
      return "'\(string.replacingOccurrences(of: "'", with: "''"))'"
  }
}

private func nullable(_ bool: Bool?) -> String {
  switch bool {
    case nil:
      return "NULL"
    case .some(let bool):
      return bool ? "true" : "false"
  }
}

private func nullable(_ date: Date?) -> String {
  switch date {
    case nil:
      return "NULL"
    case .some(let date):
      return "'\(date.isoString)'"
  }
}

private func nullable<N: Numeric>(_ string: N?) -> String {
  switch string {
    case nil:
      return "NULL"
    case .some(let number):
      return "\(number)"
  }
}

extension Postgres.Data: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    self = .string(value)
  }
}

extension Postgres.Data: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self = .int(value)
  }
}

extension Postgres.Data: ExpressibleByBooleanLiteral {
  init(booleanLiteral value: Bool) {
    self = .bool(value)
  }
}

extension Postgres.Data: Equatable {
  static func == (lhs: Postgres.Data, rhs: Postgres.Data) -> Bool {
    [lhs.typeName, lhs.param] == [rhs.typeName, rhs.param]
  }
}

extension SQL.WhereConstraint {
  func isSatisfiedBy(_ data: Postgres.Data) -> Bool {
    switch expression {
      case .isNull:
        return data.holdsNull
      case .notNull:
        return !data.holdsNull
      case .value(let op, let value):
        switch op {
          case .equals:
            return data == value
        }
    }
  }
}
