import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {
  func createFreeOrderRequest(
    req: Req,
    args: InputArgs<AppSchema.CreateFreeOrderRequestInput>
  ) throws -> Future<FreeOrderRequest> {
    future(of: FreeOrderRequest.self, on: req.eventLoop) {
      let order = try await Current.db.create(FreeOrderRequest(args.input))
      try await sendFreeOrderRequestNotifications(for: order, on: req)
      return order
    }
  }
}

private func sendFreeOrderRequestNotifications(
  for order: FreeOrderRequest,
  on request: Request
) async throws {
  let id = order.id.rawValue.uuidString.lowercased()
  if let emailTo = Env.get("FREE_ORDER_REQUEST_EMAIL_RECIPIENT") {
    let email = SendGrid.Email(
      to: .init(email: emailTo),
      from: .friendsLibrary,
      subject: "[,] Free Book Request - \(id)",
      html:
      """
      \(entry("Name", order.name))
      \(entry("Email", order.email.rawValue))
      \(entry("Requested Books", order.requestedBooks))
      \(entry("About Requester", order.aboutRequester))
      \(entry("Street", order.addressStreet))
      \(entry("Street 2", order.addressStreet2))
      \(entry("City", order.addressCity))
      \(entry("State", order.addressState))
      \(entry("Zip", order.addressZip))
      \(entry("Country", order.addressCountry))
      \(entry("Source", order.source))

      <br />
      <br />

      <a href="https://admin.friendslibrary.com/orders/new?request=\(id)">
        Create Order &raquo;
      </a>
      """
    )
    try await Current.sendGridClient.send(email)
  }

  if request.application.environment == .production {
    let text =
      "New *Spanish Free Book Order Request:*\n  → _Name_ `\(order.name)`\n  → _Books_ `\(order.requestedBooks)`\n  → _About_ `\(order.aboutRequester.replacingOccurrences(of: "\n", with: ""))`"
    await Current.slackClient.send(.order(text, emoji: .orangeBook))
  }
}

private func entry(_ key: String, _ value: String?) -> String {
  guard let value = value else {
    return ""
  }
  return
    """
    <p>
      <b>\(key):</b>&nbsp;
      \(value.replacingOccurrences(of: "\n", with: "<br />"))
    </p>
    """
}

// below auto-generated

extension Resolver {
  func getFreeOrderRequest(req: Req, args: IdentifyEntityArgs) throws -> Future<FreeOrderRequest> {
    try req.requirePermission(to: .queryOrders)
    return future(of: FreeOrderRequest.self, on: req.eventLoop) {
      try await Current.db.find(FreeOrderRequest.self, byId: args.id)
    }
  }

  func getFreeOrderRequests(req: Req, args: NoArgs) throws -> Future<[FreeOrderRequest]> {
    try req.requirePermission(to: .queryOrders)
    return future(of: [FreeOrderRequest].self, on: req.eventLoop) {
      try await Current.db.query(FreeOrderRequest.self).all()
    }
  }

  func createFreeOrderRequests(
    req: Req,
    args: InputArgs<[AppSchema.CreateFreeOrderRequestInput]>
  ) throws -> Future<[FreeOrderRequest]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [FreeOrderRequest].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(FreeOrderRequest.init))
    }
  }

  func updateFreeOrderRequest(
    req: Req,
    args: InputArgs<AppSchema.UpdateFreeOrderRequestInput>
  ) throws -> Future<FreeOrderRequest> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: FreeOrderRequest.self, on: req.eventLoop) {
      try await Current.db.update(FreeOrderRequest(args.input))
    }
  }

  func updateFreeOrderRequests(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFreeOrderRequestInput]>
  ) throws -> Future<[FreeOrderRequest]> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: [FreeOrderRequest].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(FreeOrderRequest.init))
    }
  }

  func deleteFreeOrderRequest(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<FreeOrderRequest> {
    try req.requirePermission(to: .mutateOrders)
    return future(of: FreeOrderRequest.self, on: req.eventLoop) {
      try await Current.db.delete(FreeOrderRequest.self, byId: args.id)
    }
  }
}
