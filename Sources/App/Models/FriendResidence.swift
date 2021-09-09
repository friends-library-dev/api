import Fluent
import Foundation
import Vapor

final class FriendResidence: Model, Content {
  static let schema = FriendResidence.M7.tableName

  struct Duration: Codable {
    var start: Int
    var end: Int
  }

  @ID(key: .id)
  var id: UUID?

  @Field(key: FriendResidence.M7.city)
  var city: String

  @Field(key: FriendResidence.M7.region)
  var region: String

  @OptionalField(key: FriendResidence.M7.duration)
  var duration: Duration?

  @Parent(key: FriendResidence.M7.friendId)
  var friend: Friend

  init() {}

  init(
    id: UUID? = nil,
    friendId: UUID? = nil,
    city: String,
    region: String,
    duration: Duration? = nil
  ) {
    self.id = id
    self.city = city
    self.region = region
    self.duration = duration
    if let friendId = friendId {
      self.$friend.id = friendId
    }
  }
}

extension FriendResidence {
  enum M7 {
    static let tableName = "friend_residences"
    static let id = FieldKey("id")
    static let city = FieldKey("city")
    static let region = FieldKey("region")
    static let duration = FieldKey("duration")
    static let friendId = FieldKey("friend_id")
  }
}
