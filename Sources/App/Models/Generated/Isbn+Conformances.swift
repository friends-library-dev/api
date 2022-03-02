// auto-generated, do not edit
import Foundation
import Tagged

extension Isbn: ApiModel {
  typealias Id = Tagged<Isbn, UUID>
  static var preloadedEntityType: PreloadedEntityType? {
    .isbn(Self.self)
  }
}

extension Isbn: DuetModel {
  static let tableName = M19.tableName
  static var isSoftDeletable: Bool { false }
}

extension Isbn {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
    case id
    case code
    case editionId
    case createdAt
    case updatedAt
  }
}

extension Isbn {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .code: .string(code.rawValue),
      .editionId: .uuid(editionId),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension Isbn: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Isbn>) -> Bool {
    switch constraint.column {
      case .id:
        return constraint.isSatisfiedBy(.id(self))
      case .code:
        return constraint.isSatisfiedBy(.string(code.rawValue))
      case .editionId:
        return constraint.isSatisfiedBy(.uuid(editionId))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension Isbn: Auditable {}
extension Isbn: Touchable {}
