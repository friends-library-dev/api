import Fluent
import Vapor

struct CreateFreeOrderRequests: Migration {

  func prepare(on database: Database) -> Future<Void> {
    return database.enum("free_order_request_source")
      .case("mainWebsite")
      .case("zoeWebsite")
      .create()
      .flatMap { sources in
        database.schema(FreeOrderRequest.M6.tableName)
          .id()
          .field(FreeOrderRequest.M6.name, .string, .required)
          .field(FreeOrderRequest.M6.email, .string, .required)
          .field(FreeOrderRequest.M6.requestedBooks, .string, .required)
          .field(FreeOrderRequest.M6.aboutRequester, .string, .required)
          .field(FreeOrderRequest.M6.addressStreet, .string, .required)
          .field(FreeOrderRequest.M6.addressStreet2, .string)
          .field(FreeOrderRequest.M6.addressCity, .string, .required)
          .field(FreeOrderRequest.M6.addressState, .string, .required)
          .field(FreeOrderRequest.M6.addressZip, .string, .required)
          .field(FreeOrderRequest.M6.addressCountry, .string, .required)
          .field(FreeOrderRequest.M6.source, sources, .required)
          .field(FieldKey.createdAt, .datetime, .required)
          .field(FieldKey.updatedAt, .datetime, .required)
          .create()
      }
  }

  func revert(on database: Database) -> Future<Void> {
    return database.schema(FreeOrderRequest.M6.tableName).delete()
  }
}
