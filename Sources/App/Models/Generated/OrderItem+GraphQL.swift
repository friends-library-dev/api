// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var OrderItemType: AppType<OrderItem> {
    Type(OrderItem.self) {
      Field("id", at: \.id.rawValue)
      Field("orderId", at: \.orderId.rawValue)
      Field("editionId", at: \.editionId.rawValue)
      Field("quantity", at: \.quantity)
      Field("unitPrice", at: \.unitPrice.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("order", with: \.order)
      Field("edition", with: \.edition)
    }
  }

  struct CreateOrderItemInput: Codable {
    let id: UUID?
    let orderId: UUID
    let editionId: UUID
    let quantity: Int
    let unitPrice: Int
  }

  struct UpdateOrderItemInput: Codable {
    let id: UUID
    let orderId: UUID
    let editionId: UUID
    let quantity: Int
    let unitPrice: Int
  }

  struct CreateOrderItemArgs: Codable {
    let input: AppSchema.CreateOrderItemInput
  }

  struct UpdateOrderItemArgs: Codable {
    let input: AppSchema.UpdateOrderItemInput
  }

  struct CreateOrderItemsArgs: Codable {
    let input: [AppSchema.CreateOrderItemInput]
  }

  struct UpdateOrderItemsArgs: Codable {
    let input: [AppSchema.UpdateOrderItemInput]
  }

  static var CreateOrderItemInputType: AppInput<AppSchema.CreateOrderItemInput> {
    Input(AppSchema.CreateOrderItemInput.self) {
      InputField("id", at: \.id)
      InputField("orderId", at: \.orderId)
      InputField("editionId", at: \.editionId)
      InputField("quantity", at: \.quantity)
      InputField("unitPrice", at: \.unitPrice)
    }
  }

  static var UpdateOrderItemInputType: AppInput<AppSchema.UpdateOrderItemInput> {
    Input(AppSchema.UpdateOrderItemInput.self) {
      InputField("id", at: \.id)
      InputField("orderId", at: \.orderId)
      InputField("editionId", at: \.editionId)
      InputField("quantity", at: \.quantity)
      InputField("unitPrice", at: \.unitPrice)
    }
  }

  static var getOrderItem: AppField<OrderItem, IdentifyEntityArgs> {
    Field("getOrderItem", at: Resolver.getOrderItem) {
      Argument("id", at: \.id)
    }
  }

  static var getOrderItems: AppField<[OrderItem], NoArgs> {
    Field("getOrderItems", at: Resolver.getOrderItems)
  }

  static var createOrderItem: AppField<OrderItem, AppSchema.CreateOrderItemArgs> {
    Field("createOrderItem", at: Resolver.createOrderItem) {
      Argument("input", at: \.input)
    }
  }

  static var createOrderItems: AppField<[OrderItem], AppSchema.CreateOrderItemsArgs> {
    Field("createOrderItems", at: Resolver.createOrderItems) {
      Argument("input", at: \.input)
    }
  }

  static var updateOrderItem: AppField<OrderItem, AppSchema.UpdateOrderItemArgs> {
    Field("updateOrderItem", at: Resolver.updateOrderItem) {
      Argument("input", at: \.input)
    }
  }

  static var updateOrderItems: AppField<[OrderItem], AppSchema.UpdateOrderItemsArgs> {
    Field("updateOrderItems", at: Resolver.updateOrderItems) {
      Argument("input", at: \.input)
    }
  }

  static var deleteOrderItem: AppField<OrderItem, IdentifyEntityArgs> {
    Field("deleteOrderItem", at: Resolver.deleteOrderItem) {
      Argument("id", at: \.id)
    }
  }
}

extension OrderItem {
  convenience init(_ input: AppSchema.CreateOrderItemInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      orderId: .init(rawValue: input.orderId),
      editionId: .init(rawValue: input.editionId),
      quantity: input.quantity,
      unitPrice: .init(rawValue: input.unitPrice)
    )
  }

  convenience init(_ input: AppSchema.UpdateOrderItemInput) {
    self.init(
      id: .init(rawValue: input.id),
      orderId: .init(rawValue: input.orderId),
      editionId: .init(rawValue: input.editionId),
      quantity: input.quantity,
      unitPrice: .init(rawValue: input.unitPrice)
    )
  }

  func update(_ input: AppSchema.UpdateOrderItemInput) {
    orderId = .init(rawValue: input.orderId)
    editionId = .init(rawValue: input.editionId)
    quantity = input.quantity
    unitPrice = .init(rawValue: input.unitPrice)
  }
}
