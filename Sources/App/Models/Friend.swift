import Fluent
import Vapor

final class Friend: Model, Content {
  static let schema = Friend.M6.tableName

  enum Gender: String, Codable, CaseIterable {
    case male
    case female
    case mixed
  }

  @ID(key: .id)
  var id: UUID?

  @Enum(key: Friend.M6.lang)
  var lang: Lang

  @Field(key: Friend.M6.name)
  var name: String

  @Field(key: Friend.M6.slug)
  var slug: String

  @Enum(key: Friend.M6.gender)
  var gender: Gender

  @Field(key: Friend.M6.description)
  var description: String

  @OptionalField(key: Friend.M6.born)
  var born: Int?

  @Field(key: Friend.M6.died)
  var died: Int

  @Field(key: Friend.M6.isCompilations)
  var isCompilations: Bool

  @Field(key: Friend.M6.published)
  var published: Date?

  @Timestamp(key: FieldKey.createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: FieldKey.updatedAt, on: .update)
  var updatedAt: Date?

  @Children(for: \FriendResidence.$friend)
  var residences: [FriendResidence]

  init() {}
}

extension Friend {
  enum M6 {
    static let tableName = "friends"
    static let id = FieldKey("id")
    static let lang = FieldKey("lang")
    static let name = FieldKey("name")
    static let slug = FieldKey("slug")
    static let gender = FieldKey("gender")
    static let description = FieldKey("description")
    static let born = FieldKey("born")
    static let died = FieldKey("died")
    static let isCompilations = FieldKey("is_compilations")
    static let published = FieldKey("published")
  }
}
