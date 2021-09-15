import GraphQLKit
import XCTVapor
import XCTVaporUtils

@testable import App

final class OrderResolverTests: GraphQLTestCase {
  override func configureApp(_ app: Application) throws {
    return try configure(app)
  }

  func testCreateOrder() throws {
    let order: Map = .dictionary([
      "paymentId": .string("stripe-123"),
      "printJobStatus": .string("presubmit"),
      "shippingLevel": .string("mail"),
      "amount": .int(33),
      "shipping": .int(33),
      "taxes": .int(33),
      "ccFeeOffset": .int(33),
      "email": .string("jared@netrivet.com"),
      "addressName": .string("Jared Henderson"),
      "addressStreet": .string("123 Magnolia Lane"),
      "addressCity": .string("New York"),
      "addressState": .string("NY"),
      "addressZip": .string("90210"),
      "addressCountry": .string("US"),
      "lang": .string("en"),
      "source": .string("website"),
      "items": .array([
        .dictionary([
          "title": .string("Journal of George Fox"),
          "documentId": .string("9050edba-197e-498f-9fb8-61c36abae59e"),
          "editionType": .string("original"),
          "quantity": .int(1),
          "unitPrice": .int(333),
        ])
      ]),
    ])

    GraphQLTest(
      """
      mutation CreateOrder($input: CreateOrderInput!) {
        order: createOrder(input: $input) {
          paymentId
          printJobStatus
          shippingLevel
          email
          addressName
          addressStreet
          addressCity
          addressState
          addressZip
          addressCountry
          lang
          source
          items {
            title
            documentId
            editionType
            quantity
            unitPrice
          }
        }
      }
      """,
      expectedData: .containsKVPs([
        "paymentId": "stripe-123",
        "printJobStatus": "presubmit",
        "shippingLevel": "mail",
        "email": "jared@netrivet.com",
        "addressName": "Jared Henderson",
        "addressStreet": "123 Magnolia Lane",
        "addressCity": "New York",
        "addressState": "NY",
        "addressZip": "90210",
        "addressCountry": "US",
        "lang": "en",
        "source": "website",
        "title": "Journal of George Fox",
        "documentId": "9050EDBA-197E-498F-9FB8-61C36ABAE59E",
        "editionType": "original",
        "quantity": 1,
        "unitPrice": 333,
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(self, variables: ["input": order])
  }

  func testCreateOrderWithFreeRequestId() throws {
    let freeOrderRequest = FreeOrderRequest.createFixture(on: app.db)
    let order: Map = .dictionary([
      "freeOrderRequestId": .string(freeOrderRequest.id!.uuidString),
      "paymentId": .string("stripe-123"),
      "printJobStatus": .string("presubmit"),
      "shippingLevel": .string("mail"),
      "amount": .int(33),
      "shipping": .int(33),
      "taxes": .int(33),
      "ccFeeOffset": .int(33),
      "email": .string("jared@netrivet.com"),
      "addressName": .string("Jared Henderson"),
      "addressStreet": .string("123 Magnolia Lane"),
      "addressCity": .string("New York"),
      "addressState": .string("NY"),
      "addressZip": .string("90210"),
      "addressCountry": .string("US"),
      "lang": .string("en"),
      "source": .string("website"),
      "items": .array([
        .dictionary([
          "title": .string("Journal of George Fox"),
          "documentId": .string("9050edba-197e-498f-9fb8-61c36abae59e"),
          "editionType": .string("original"),
          "quantity": .int(1),
          "unitPrice": .int(333),
        ])
      ]),
    ])

    GraphQLTest(
      """
      mutation CreateOrder($input: CreateOrderInput!) {
        order: createOrder(input: $input) {
          freeOrderRequest {
            id
          }
        }
      }
      """,
      expectedData: .containsKVPs(["id": freeOrderRequest.id!.uuidString]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(self, variables: ["input": order])
  }

  func testUpdateOrder() throws {
    let order = Order.createFixture(on: app.db)

    let input: Map = .dictionary([
      "id": .string(order.id!.uuidString),
      "printJobId": .number(12345),
      "printJobStatus": .string("accepted"),
    ])

    GraphQLTest(
      """
      mutation UpdateOrder($input: UpdateOrderInput!) {
        order: updateOrder(input: $input) {
          printJobId
          printJobStatus
        }
      }
      """,
      expectedData: .containsKVPs([
        "printJobId": 12345,
        "printJobStatus": "accepted",
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(self, variables: ["input": input])
  }

  func testUpdateOrders() throws {
    let order1 = Order.createFixture(on: app.db)
    let order2 = Order.createFixture(on: app.db)

    let input: Map = .array([
      .dictionary([
        "id": .string(order1.id!.uuidString),
        "printJobId": .number(5555),
      ]),
      .dictionary([
        "id": .string(order2.id!.uuidString),
        "printJobId": .number(3333),
      ]),
    ])

    GraphQLTest(
      """
      mutation UpdateOrders($input: [UpdateOrderInput!]!) {
        order: updateOrders(input: $input) {
          printJobId
        }
      }
      """,
      expectedData: .containsAll(["5555", "3333"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(self, variables: ["input": input])
  }

  func testGetOrderById() throws {
    let order = Order.createFixture(on: app.db) {
      $0.printJobId = 234432
    }

    GraphQLTest(
      """
      query {
        order: getOrder(id: "\(order.id!.uuidString)") {
          printJobId
        }
      }
      """,
      expectedData: .containsKVPs(["printJobId": 234432]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(self)
  }

  func testGetOrderByIdFailsWithWrongTokenScope() throws {
    let order = Order.createFixture(on: app.db)
    GraphQLTest(
      """
      query {
        order: getOrder(id: "\(order.id!.uuidString)") {
          printJobId
        }
      }
      """,
      expectedError: .status(.unauthorized),
      headers: [.authorization: "Bearer \(Seeded.tokens.queryDownloads)"]  // 👋 <-- bad scope
    ).run(self)
  }

  func testGetOrdersByPrintJobStatus() throws {
    let order1 = Order.createFixture(on: app.db) {
      $0.printJobStatus = .bricked
    }
    let order2 = Order.createFixture(on: app.db) {
      $0.printJobStatus = .bricked
    }

    GraphQLTest(
      """
      query {
        orders: getOrders(printJobStatus: "bricked") {
          id
        }
      }
      """,
      expectedData: .containsUUIDs([order1.id!, order2.id!]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(self)
  }
}
