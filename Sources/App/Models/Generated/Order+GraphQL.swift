// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var OrderType: ModelType<Order> {
    Type(Order.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("lang", at: \.lang)
      Field("source", at: \.source)
      Field("paymentId", at: \.paymentId.rawValue)
      Field("printJobId", at: \.printJobId?.rawValue)
      Field("printJobStatus", at: \.printJobStatus)
      Field("amountInCents", at: \.amount.rawValue)
      Field("taxesInCents", at: \.taxes.rawValue)
      Field("feesInCents", at: \.fees.rawValue)
      Field("ccFeeOffsetInCents", at: \.ccFeeOffset.rawValue)
      Field("shippingInCents", at: \.shipping.rawValue)
      Field("shippingLevel", at: \.shippingLevel)
      Field("email", at: \.email.rawValue)
      Field("addressName", at: \.addressName)
      Field("addressStreet", at: \.addressStreet)
      Field("addressStreet2", at: \.addressStreet2)
      Field("addressCity", at: \.addressCity)
      Field("addressState", at: \.addressState)
      Field("addressZip", at: \.addressZip)
      Field("addressCountry", at: \.addressCountry)
      Field("freeOrderRequestId", at: \.freeOrderRequestId?.rawValue.lowercased)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("address", at: \.address)
      Field("items", with: \.items)
      Field("freeOrderRequest", with: \.freeOrderRequest)
    }
  }

  struct CreateOrderInput: Codable {
    let id: UUID?
    let lang: Lang
    let source: Order.OrderSource
    let paymentId: String
    let printJobId: Int?
    let printJobStatus: Order.PrintJobStatus
    let amount: Int
    let taxes: Int
    let fees: Int
    let ccFeeOffset: Int
    let shipping: Int
    let shippingLevel: Order.ShippingLevel
    let email: String
    let addressName: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let freeOrderRequestId: UUID?
  }

  struct UpdateOrderInput: Codable {
    let id: UUID
    let lang: Lang
    let source: Order.OrderSource
    let paymentId: String
    let printJobId: Int?
    let printJobStatus: Order.PrintJobStatus
    let amount: Int
    let taxes: Int
    let fees: Int
    let ccFeeOffset: Int
    let shipping: Int
    let shippingLevel: Order.ShippingLevel
    let email: String
    let addressName: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let freeOrderRequestId: UUID?
  }

  static var CreateOrderInputType: AppInput<AppSchema.CreateOrderInput> {
    Input(AppSchema.CreateOrderInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("source", at: \.source)
      InputField("paymentId", at: \.paymentId)
      InputField("printJobId", at: \.printJobId)
      InputField("printJobStatus", at: \.printJobStatus)
      InputField("amount", at: \.amount)
      InputField("taxes", at: \.taxes)
      InputField("fees", at: \.fees)
      InputField("ccFeeOffset", at: \.ccFeeOffset)
      InputField("shipping", at: \.shipping)
      InputField("shippingLevel", at: \.shippingLevel)
      InputField("email", at: \.email)
      InputField("addressName", at: \.addressName)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("freeOrderRequestId", at: \.freeOrderRequestId)
    }
  }

  static var UpdateOrderInputType: AppInput<AppSchema.UpdateOrderInput> {
    Input(AppSchema.UpdateOrderInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("source", at: \.source)
      InputField("paymentId", at: \.paymentId)
      InputField("printJobId", at: \.printJobId)
      InputField("printJobStatus", at: \.printJobStatus)
      InputField("amount", at: \.amount)
      InputField("taxes", at: \.taxes)
      InputField("fees", at: \.fees)
      InputField("ccFeeOffset", at: \.ccFeeOffset)
      InputField("shipping", at: \.shipping)
      InputField("shippingLevel", at: \.shippingLevel)
      InputField("email", at: \.email)
      InputField("addressName", at: \.addressName)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("freeOrderRequestId", at: \.freeOrderRequestId)
    }
  }

  static var getOrder: AppField<Order, IdentifyEntity> {
    Field("getOrder", at: Resolver.getOrder) {
      Argument("id", at: \.id)
    }
  }

  static var getOrders: AppField<[Order], NoArgs> {
    Field("getOrders", at: Resolver.getOrders)
  }

  static var createOrder: AppField<IdentifyEntity, InputArgs<CreateOrderInput>> {
    Field("createOrder", at: Resolver.createOrder) {
      Argument("input", at: \.input)
    }
  }

  static var createOrders: AppField<[IdentifyEntity], InputArgs<[CreateOrderInput]>> {
    Field("createOrders", at: Resolver.createOrders) {
      Argument("input", at: \.input)
    }
  }

  static var updateOrder: AppField<Order, InputArgs<UpdateOrderInput>> {
    Field("updateOrder", at: Resolver.updateOrder) {
      Argument("input", at: \.input)
    }
  }

  static var updateOrders: AppField<[Order], InputArgs<[UpdateOrderInput]>> {
    Field("updateOrders", at: Resolver.updateOrders) {
      Argument("input", at: \.input)
    }
  }

  static var deleteOrder: AppField<Order, IdentifyEntity> {
    Field("deleteOrder", at: Resolver.deleteOrder) {
      Argument("id", at: \.id)
    }
  }
}

extension Order {
  convenience init(_ input: AppSchema.CreateOrderInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      printJobId: input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil,
      lang: input.lang,
      source: input.source,
      paymentId: .init(rawValue: input.paymentId),
      printJobStatus: input.printJobStatus,
      amount: .init(rawValue: input.amount),
      taxes: .init(rawValue: input.taxes),
      fees: .init(rawValue: input.fees),
      ccFeeOffset: .init(rawValue: input.ccFeeOffset),
      shipping: .init(rawValue: input.shipping),
      shippingLevel: input.shippingLevel,
      email: .init(rawValue: input.email),
      addressName: input.addressName,
      addressStreet: input.addressStreet,
      addressStreet2: input.addressStreet2,
      addressCity: input.addressCity,
      addressState: input.addressState,
      addressZip: input.addressZip,
      addressCountry: input.addressCountry,
      freeOrderRequestId: input
        .freeOrderRequestId != nil ? .init(rawValue: input.freeOrderRequestId!) : nil
    )
  }

  convenience init(_ input: AppSchema.UpdateOrderInput) {
    self.init(
      id: .init(rawValue: input.id),
      printJobId: input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil,
      lang: input.lang,
      source: input.source,
      paymentId: .init(rawValue: input.paymentId),
      printJobStatus: input.printJobStatus,
      amount: .init(rawValue: input.amount),
      taxes: .init(rawValue: input.taxes),
      fees: .init(rawValue: input.fees),
      ccFeeOffset: .init(rawValue: input.ccFeeOffset),
      shipping: .init(rawValue: input.shipping),
      shippingLevel: input.shippingLevel,
      email: .init(rawValue: input.email),
      addressName: input.addressName,
      addressStreet: input.addressStreet,
      addressStreet2: input.addressStreet2,
      addressCity: input.addressCity,
      addressState: input.addressState,
      addressZip: input.addressZip,
      addressCountry: input.addressCountry,
      freeOrderRequestId: input
        .freeOrderRequestId != nil ? .init(rawValue: input.freeOrderRequestId!) : nil
    )
  }

  func update(_ input: AppSchema.UpdateOrderInput) {
    lang = input.lang
    source = input.source
    paymentId = .init(rawValue: input.paymentId)
    printJobId = input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil
    printJobStatus = input.printJobStatus
    amount = .init(rawValue: input.amount)
    taxes = .init(rawValue: input.taxes)
    fees = .init(rawValue: input.fees)
    ccFeeOffset = .init(rawValue: input.ccFeeOffset)
    shipping = .init(rawValue: input.shipping)
    shippingLevel = input.shippingLevel
    email = .init(rawValue: input.email)
    addressName = input.addressName
    addressStreet = input.addressStreet
    addressStreet2 = input.addressStreet2
    addressCity = input.addressCity
    addressState = input.addressState
    addressZip = input.addressZip
    addressCountry = input.addressCountry
    freeOrderRequestId = input
      .freeOrderRequestId != nil ? .init(rawValue: input.freeOrderRequestId!) : nil
    updatedAt = Current.date()
  }
}
