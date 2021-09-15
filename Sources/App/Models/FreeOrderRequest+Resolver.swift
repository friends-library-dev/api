import Fluent
import Foundation
import Graphiti
import Vapor
import VaporUtils

struct CreateFreeOrderRequestInput: Codable {
  let name: String
  let email: String
  let requestedBooks: String
  let aboutRequester: String
  let addressStreet: String
  let addressStreet2: String?
  let addressCity: String
  let addressState: String
  let addressZip: String
  let addressCountry: String
  let source: String
}

extension Resolver {

  func getFreeOrderRequest(
    request: Request,
    args: IdentifyEntityArgs
  ) throws -> Future<FreeOrderRequest> {
    FreeOrderRequest
      .find(args.id, on: request.db)
      .unwrap(or: Abort(.notFound))
  }

  struct CreateFreeOrderRequestArgs: Codable {
    let input: CreateFreeOrderRequestInput
  }

  func createFreeOrderRequest(
    request: Request,
    args: CreateFreeOrderRequestArgs
  ) throws -> Future<FreeOrderRequest> {
    let order = FreeOrderRequest()
    order.name = args.input.name
    order.email = args.input.email
    order.requestedBooks = args.input.requestedBooks
    order.aboutRequester = args.input.aboutRequester
    order.addressStreet = args.input.addressStreet
    order.addressStreet2 = args.input.addressStreet2
    order.addressCity = args.input.addressCity
    order.addressState = args.input.addressState
    order.addressZip = args.input.addressZip
    order.addressCountry = args.input.addressCountry
    order.source = args.input.source

    return order.create(on: request.db).flatMap {
      sendFreeOrderRequestNotifications(for: order, on: request)
        .map { order }
    }
  }
}

private func sendFreeOrderRequestNotifications(
  for order: FreeOrderRequest,
  on request: Request
) -> Future<Void> {
  let id = order.id!.uuidString.lowercased()
  var emailFuture = request.eventLoop.makeSucceededVoidFuture()
  if let emailTo = Environment.get("FREE_ORDER_REQUEST_EMAIL_RECIPIENT") {
    emailFuture = SendGridEmail(
      to: .init(email: emailTo),
      from: .init(
        email: "notifications@graphql-api.friendslibrary.com",
        name: "Friends Library"
      ),
      subject: "[,] Free Book Request - \(id)",
      html:
        """
        \(entry("Name", order.name))
        \(entry("Email", order.email))
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

        <a href="https://orders.friendslibrary.com?request=\(id)">
          Create Order &raquo;
        </a>
        """
    )
    .send(on: request.client, withKey: Environment.SENDGRID_API_KEY)
    .transform(to: ())
  }

  var slackFuture = request.eventLoop.makeSucceededVoidFuture()
  if request.application.environment == .production {
    slackFuture = SlackMessage(
      text:
        "New *Spanish Free Book Order Request:*\n  → _Name_ `\(order.name)`\n  → _Books_ `\(order.requestedBooks)`\n  → _About_ `\(order.aboutRequester.replacingOccurrences(of: "\n", with: ""))`",
      channel: "orders",
      username: "FLP Api Bot",
      emoji: .custom("orange_book")
    )
    .send(on: request.client, withToken: Environment.SLACK_API_TOKEN)
    .transform(to: ())
  }

  return [emailFuture, slackFuture].flatten(on: request.eventLoop)
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
