import Fluent
import Vapor

struct CreateFriendResidences: Migration {

  func prepare(on database: Database) -> Future<Void> {
    database.schema(FriendResidence.M7.tableName)
      .id()
      .field(
        FriendResidence.M7.friendId,
        .uuid,
        .required,
        .references(Friend.M6.tableName, FieldKey.id, onDelete: .cascade)
      )
      .field(FriendResidence.M7.city, .string, .required)
      .field(FriendResidence.M7.region, .string, .required)
      .field(FriendResidence.M7.duration, .dictionary)
      .create()
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(FriendResidence.M7.tableName).delete()
  }
}
