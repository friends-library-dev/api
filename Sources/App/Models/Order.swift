import Fluent
import Vapor

final class Order: Model, Content {
  static let schema = M2.tableName

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

  // @Children(for: \OrderItem.$order)
  // var items: [OrderItem]

  @OptionalParent(key: M7.freeOrderRequestId)
  var freeOrderRequest: FreeOrderRequest?

  @Field(key: M2.paymentId)
  var paymentId: String

  @Enum(key: M2.printJobStatus)
  var printJobStatus: PrintJobStatus

  @OptionalField(key: M2.printJobId)
  var printJobId: Int?

  @Field(key: M2.amount)
  var amount: Int

  @Field(key: M2.shipping)
  var shipping: Int

  @Field(key: M2.taxes)
  var taxes: Int

  @Field(key: M2.ccFeeOffset)
  var ccFeeOffset: Int

  @Enum(key: M2.shippingLevel)
  var shippingLevel: ShippingLevel

  @Field(key: M2.email)
  var email: String

  @Field(key: M2.addressName)
  var addressName: String

  @Field(key: M2.addressStreet)
  var addressStreet: String

  @OptionalField(key: M2.addressStreet2)
  var addressStreet2: String?

  @Field(key: M2.addressCity)
  var addressCity: String

  @Field(key: M2.addressState)
  var addressState: String

  @Field(key: M2.addressZip)
  var addressZip: String

  @Field(key: M2.addressCountry)
  var addressCountry: String

  @Enum(key: M2.lang)
  var lang: Lang

  @Enum(key: M2.source)
  var source: OrderSource

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Timestamp(key: .updatedAt, on: .update)
  var updatedAt: Date?

  init() {}
}

extension Order {
  enum M2 {
    static let tableName = "orders"
    static let id = FieldKey("id")
    static let paymentId = FieldKey("payment_id")
    static let printJobStatus = FieldKey("print_job_status")
    static let printJobId = FieldKey("print_job_id")
    static let amount = FieldKey("amount")
    static let shipping = FieldKey("shipping")
    static let taxes = FieldKey("taxes")
    static let ccFeeOffset = FieldKey("cc_fee_offset")
    static let shippingLevel = FieldKey("shipping_level")
    static let email = FieldKey("email")
    static let addressName = FieldKey("address_name")
    static let addressStreet = FieldKey("address_street")
    static let addressStreet2 = FieldKey("address_street2")
    static let addressCity = FieldKey("address_city")
    static let addressState = FieldKey("address_state")
    static let addressZip = FieldKey("address_zip")
    static let addressCountry = FieldKey("address_country")
    static let lang = FieldKey("lang")
    static let source = FieldKey("source")

    enum PrintJobStatusEnum {
      static let name = "order_print_job_status"
      static let casePresubmit = "presubmit"
      static let casePending = "pending"
      static let caseAccepted = "accepted"
      static let caseRejected = "rejected"
      static let caseShipped = "shipped"
      static let caseCanceled = "canceled"
      static let caseBricked = "bricked"
    }

    enum ShippingLevelEnum {
      static let name = "order_shipping_level"
      static let caseMail = "mail"
      static let casePriorityMail = "priorityMail"
      static let caseGroundHd = "groundHd"
      static let caseGround = "ground"
      static let caseExpedited = "expedited"
      static let caseExpress = "express"
    }

    enum LangEnum {
      static let name = "lang"
      static let caseEn = "en"
      static let caseEs = "es"
    }

    enum SourceEnum {
      static let name = "order_source"
      static let caseWebsite = "website"
      static let caseInternal = "internal"
    }
  }

  enum M7 {
    static let freeOrderRequestId = FieldKey("free_order_request_id")
  }
}
