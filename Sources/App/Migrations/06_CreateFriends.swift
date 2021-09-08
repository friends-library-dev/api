import Fluent
import Vapor

struct CreateFriends: Migration {

  func prepare(on database: Database) -> Future<Void> {
    let genderFuture = database.enum("gender")
      .case("male")
      .case("female")
      .case("mixed")
      .create()

    let langFuture = database.enum("lang").read()

    return genderFuture.and(langFuture).flatMap { enums -> Future<Void> in
      let (genders, langs) = enums
      return database.schema(Friend.M6.tableName)
        .id()
        .field(Friend.M6.lang, langs, .required)
        .field(Friend.M6.name, .string, .required)
        .field(Friend.M6.slug, .string, .required)
        .field(Friend.M6.gender, genders, .required)
        .field(Friend.M6.description, .string, .required)
        .field(Friend.M6.born, .int)
        .field(Friend.M6.died, .int, .required)
        .field(Friend.M6.isCompilations, .bool, .required)
        .field(Friend.M6.published, .datetime)
        .field(FieldKey.createdAt, .datetime, .required)
        .field(FieldKey.updatedAt, .datetime, .required)
        .unique(on: Friend.M6.lang, Friend.M6.name, Friend.M6.slug)
        .create()
    }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(Friend.M6.tableName).delete()
  }
}
