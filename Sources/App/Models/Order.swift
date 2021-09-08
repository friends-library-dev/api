import Fluent
import Vapor

final class Order: Model, Content {
  static let schema = "orders"

  enum PrintJobStatus: String, Codable, CaseIterable {
    case presubmit
    case pending
    case accepted
    case rejected
    case shipped
    case canceled
    case bricked
  }

  enum ShippingLevel: String, Codable, CaseIterable {
    case mail
    case priorityMail
    case groundHd
    case ground
    case expedited
    case express
  }

  enum OrderSource: String, Codable, CaseIterable {
    case website
    case `internal`
  }

  @ID(key: .id)
  var id: UUID?

  @Children(for: \OrderItem.$order)
  var items: [OrderItem]

  @Field(key: "payment_id")
  var paymentId: String

  @Enum(key: "print_job_status")
  var printJobStatus: PrintJobStatus

  @OptionalField(key: "print_job_id")
  var printJobId: Int?

  @Field(key: "amount")
  var amount: Int

  @Field(key: "shipping")
  var shipping: Int

  @Field(key: "taxes")
  var taxes: Int

  @Field(key: "cc_fee_offset")
  var ccFeeOffset: Int

  @Enum(key: "shipping_level")
  var shippingLevel: ShippingLevel

  @Field(key: "email")
  var email: String

  @Field(key: "address_name")
  var addressName: String

  @Field(key: "address_street")
  var addressStreet: String

  @OptionalField(key: "address_street2")
  var addressStreet2: String?

  @Field(key: "address_city")
  var addressCity: String

  @Field(key: "address_state")
  var addressState: String

  @Field(key: "address_zip")
  var addressZip: String

  @Field(key: "address_country")
  var addressCountry: String

  @Enum(key: "lang")
  var lang: Lang

  @Enum(key: "source")
  var source: OrderSource

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  init() {}
}
