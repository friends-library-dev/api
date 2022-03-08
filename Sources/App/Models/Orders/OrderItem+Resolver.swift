import Vapor

// below auto-generated

extension Resolver {
  func getOrderItem(req: Req, args: IdentifyEntity) throws -> Future<OrderItem> {
    try req.requirePermission(to: .queryOrders)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.find(OrderItem.self, byId: args.id)
    }
  }

  func getOrderItems(req: Req, args: NoArgs) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .queryOrders)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.query(OrderItem.self).all()
    }
  }

  func createOrderItem(
    req: Req,
    args: InputArgs<AppSchema.CreateOrderItemInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(OrderItem(args.input)).identity
    }
  }

  func createOrderItems(
    req: Req,
    args: InputArgs<[AppSchema.CreateOrderItemInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(OrderItem.init)).map(\.identity)
    }
  }

  func updateOrderItem(
    req: Req,
    args: InputArgs<AppSchema.UpdateOrderItemInput>
  ) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.update(OrderItem(args.input))
    }
  }

  func updateOrderItems(
    req: Req,
    args: InputArgs<[AppSchema.UpdateOrderItemInput]>
  ) throws -> Future<[OrderItem]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [OrderItem].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(OrderItem.init))
    }
  }

  func deleteOrderItem(req: Req, args: IdentifyEntity) throws -> Future<OrderItem> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: OrderItem.self, on: req.eventLoop) {
      try await Current.db.delete(OrderItem.self, byId: args.id)
    }
  }
}
