import Fluent
import Foundation
import Graphiti
import Vapor

struct UpdateOrderInput: Codable {
  let id: UUID
  let printJobStatus: Order.PrintJobStatus?
  let printJobId: Int?
}

struct CreateOrderInput: Codable {
  struct Item: Codable {
    let title: String
    let documentId: UUID
    let editionType: EditionType
    let quantity: Int
    let unitPrice: Int
  }

  let id: UUID?
  let freeOrderRequestId: UUID?
  let paymentId: String
  let printJobStatus: Order.PrintJobStatus
  let printJobId: Int?
  let amount: Int
  let shipping: Int
  let taxes: Int
  let ccFeeOffset: Int
  let shippingLevel: Order.ShippingLevel
  let email: String
  let addressName: String
  let addressStreet: String
  let addressStreet2: String?
  let addressCity: String
  let addressState: String
  let addressZip: String
  let addressCountry: String
  let lang: Lang
  let source: Order.OrderSource
  let items: [Item]
}

extension Resolver {
  struct CreateOrderArgs: Codable {
    let input: CreateOrderInput
  }

  func createOrder(
    request: Request,
    args: CreateOrderArgs
  ) throws -> Future<Order> {
    try request.requirePermission(to: .mutateOrders)
    let order = Order()
    if let id = args.input.id {
      order.id = id
    }
    order.$freeOrderRequest.id = args.input.freeOrderRequestId
    order.paymentId = args.input.paymentId
    order.printJobStatus = args.input.printJobStatus
    order.printJobId = args.input.printJobId
    order.amount = args.input.amount
    order.shipping = args.input.shipping
    order.taxes = args.input.taxes
    order.ccFeeOffset = args.input.ccFeeOffset
    order.shippingLevel = args.input.shippingLevel
    order.email = args.input.email
    order.addressName = args.input.addressName
    order.addressStreet = args.input.addressStreet
    order.addressStreet2 = args.input.addressStreet2
    order.addressCity = args.input.addressCity
    order.addressState = args.input.addressState
    order.addressZip = args.input.addressZip
    order.addressCountry = args.input.addressCountry
    order.lang = args.input.lang
    order.source = args.input.source
    return order.create(on: request.db).flatMap { _ in
      let items = args.input.items.map { item -> OrderItem in
        let orderItem = OrderItem()
        orderItem.title = item.title
        orderItem.documentId = item.documentId
        orderItem.editionType = item.editionType
        orderItem.quantity = item.quantity
        orderItem.unitPrice = item.unitPrice
        return orderItem
      }
      return order.$items.create(items, on: request.db).map { order }
    }
  }

  func getOrder(
    request: Request,
    args: IdentifyEntityArgs
  ) throws -> Future<Order> {
    try request.requirePermission(to: .queryOrders)
    return Order.query(on: request.db)
      .with(\.$items)
      .filter(\.$id == args.id)
      .first()
      .unwrap(or: Abort(.notFound))
  }

  struct GetOrdersArgs: Codable {
    let printJobStatus: Order.PrintJobStatus?
  }

  func getOrders(
    request: Request,
    args: GetOrdersArgs
  ) throws -> Future<[Order]> {
    try request.requirePermission(to: .queryOrders)
    var query = Order.query(on: request.db)
    if let printJobStatus = args.printJobStatus {
      query = query.filter(\.$printJobStatus == printJobStatus)
    }
    return query.all()
  }

  struct UpdateOrderArgs: Codable {
    let input: UpdateOrderInput
  }

  func updateOrder(
    request: Request,
    args: UpdateOrderArgs
  ) throws -> Future<Order> {
    try request.requirePermission(to: .mutateOrders)
    return Order.find(args.input.id, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { order in
        if let printJobId = args.input.printJobId {
          order.printJobId = printJobId
        }
        if let printJobStatus = args.input.printJobStatus {
          order.printJobStatus = printJobStatus
        }
        return order.save(on: request.db).map { order }
      }
  }

  struct UpdateOrdersArgs: Codable {
    let input: [UpdateOrderInput]
  }

  func updateOrders(
    request: Request,
    args: UpdateOrdersArgs
  ) throws -> Future<[Order]> {
    try request.requirePermission(to: .mutateOrders)
    return try args.input.map { input in
      try updateOrder(request: request, args: UpdateOrderArgs(input: input))
    }.flatten(on: request.eventLoop)
  }
}
