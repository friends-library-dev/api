import Fluent
import FluentSQL
import Tagged
import Vapor

struct DatabaseClient {
  // tokens
  var createToken: (Token) throws -> Future<Void>
  var getTokenByValue: (Token.Value) throws -> Future<Token>
  var createTokenScope: (TokenScope) throws -> Future<Void>
  var getTokenScopes: (Token.Id) throws -> Future<[TokenScope]>

  // orders
  var deleteAllOrders: () throws -> Future<Void>
  var createOrder: (Order) throws -> Future<Void>
  var getOrder: (Order.Id) throws -> Future<Order>
  var getOrdersByPrintJobStatus: (Order.PrintJobStatus) throws -> Future<[Order]>
  var updateOrder: (UpdateOrderInput) throws -> Future<Order>
}

extension DatabaseClient {
  static let notImplemented = DatabaseClient(
    // tokens
    createToken: { _ in throw Abort(.notImplemented) },
    getTokenByValue: { _ in throw Abort(.notImplemented) },
    createTokenScope: { _ in throw Abort(.notImplemented) },
    getTokenScopes: { _ in throw Abort(.notImplemented) },

    // orders
    deleteAllOrders: { throw Abort(.notImplemented) },
    createOrder: { _ in throw Abort(.notImplemented) },
    getOrder: { _ in throw Abort(.notImplemented) },
    getOrdersByPrintJobStatus: { _ in throw Abort(.notImplemented) },
    updateOrder: { _ in throw Abort(.notImplemented) }
  )
}

extension DatabaseClient {
  static func live(db: SQLDatabase) -> DatabaseClient {
    var client: DatabaseClient = .notImplemented
    TokenRepository(db: db).assign(client: &client)
    OrderRepository(db: db).assign(client: &client)
    return client
  }
}

extension DatabaseClient {
  static func mock(eventLoop: EventLoop) -> DatabaseClient {
    let mockDb = MockDb()
    var client: DatabaseClient = .notImplemented
    MockTokenRepository(db: mockDb, eventLoop: eventLoop).assign(client: &client)
    MockOrderRepository(db: mockDb, eventLoop: eventLoop).assign(client: &client)
    return client
  }
}
