import Fluent
import Vapor

final class FreeOrderRequest: Model, Content {
  static let schema = FreeOrderRequest.M6.tableName

  @ID(key: .id)
  var id: UUID?

  @Field(key: FreeOrderRequest.M6.name)
  var name: String

  @Field(key: FreeOrderRequest.M6.email)
  var email: String

  @Field(key: FreeOrderRequest.M6.requestedBooks)
  var requestedBooks: String

  @Field(key: FreeOrderRequest.M6.aboutRequester)
  var aboutRequester: String

  @Field(key: FreeOrderRequest.M6.addressStreet)
  var addressStreet: String

  @OptionalField(key: FreeOrderRequest.M6.addressStreet2)
  var addressStreet2: String?

  @Field(key: FreeOrderRequest.M6.addressCity)
  var addressCity: String

  @Field(key: FreeOrderRequest.M6.addressState)
  var addressState: String

  @Field(key: FreeOrderRequest.M6.addressZip)
  var addressZip: String

  @Field(key: FreeOrderRequest.M6.addressCountry)
  var addressCountry: String

  @Field(key: FreeOrderRequest.M6.source)
  var source: String

  @Timestamp(key: FieldKey.createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: FieldKey.updatedAt, on: .update)
  var updatedAt: Date?

  init() {}
}

extension FreeOrderRequest {
  enum M6 {
    static let tableName = "free_order_requests"
    static let id = FieldKey("id")
    static let name = FieldKey("name")
    static let email = FieldKey("email")
    static let requestedBooks = FieldKey("requested_books")
    static let aboutRequester = FieldKey("about_requester")
    static let addressStreet = FieldKey("address_street")
    static let addressStreet2 = FieldKey("address_street2")
    static let addressCity = FieldKey("address_city")
    static let addressState = FieldKey("address_state")
    static let addressZip = FieldKey("address_zip")
    static let addressCountry = FieldKey("address_country")
    static let source = FieldKey("source")
  }
}
