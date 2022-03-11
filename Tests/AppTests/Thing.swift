import Foundation
import Tagged

@testable import App

final class Thing: Codable {
  enum Foobar: String, Codable {
    case foo
    case bar
  }

  var id: Id
  var foo: String
  var bar: Int
  var baz: Bool
  var foobar: Foobar
  var optFoobar: Foobar?
  var optBar: Int?
  var optFoo: String?
  var createdAt = Current.date()
  var updatedAt = Current.date()
  var deletedAt: Date?

  var isValid: Bool { true }

  init(
    id: Id = .init(),
    foo: String = "foo",
    bar: Int = 123,
    baz: Bool = true,
    foobar: Foobar = .foo
  ) {
    self.id = id
    self.foo = foo
    self.bar = bar
    self.baz = baz
    self.foobar = foobar
  }
}

// extensions

extension Thing: ApiModel {
  typealias Id = Tagged<Thing, UUID>
}

extension Thing: DuetModel {
  static let tableName = "things"
  static let isSoftDeletable = true
}

extension Thing.Foobar: PostgresEnum {
  var dataType: String { "foobars" }
}

extension Thing {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .foo: .string(foo),
      .bar: .int(bar),
      .baz: .bool(baz),
      .optBar: .int(optBar),
      .optFoo: .string(optFoo),
      .foobar: .enum(foobar),
      .optFoobar: .enum(optFoobar),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }

  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case foo
    case bar
    case baz
    case optBar
    case optFoo
    case foobar
    case optFoobar
    case createdAt
    case updatedAt
    case deletedAt
  }
}

extension Thing: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Thing>) -> Bool {
    true
  }
}
