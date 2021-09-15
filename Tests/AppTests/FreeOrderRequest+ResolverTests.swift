import GraphQLKit
import XCTVapor
import XCTVaporUtils

@testable import App

final class FreeOrderRequestResolverTests: GraphQLTestCase {
  override func configureApp(_ app: Application) throws {
    return try configure(app)
  }

  func testQueryFreeOrder() throws {
    let request = FreeOrderRequest.createFixture(on: app.db)

    GraphQLTest(
      """
      query {
        request: getFreeOrderRequest(id: "\(request.id!.uuidString)") {
          email
          name
          requestedBooks
          aboutRequester
          addressStreet
          addressCity
          addressStreet
          addressCity
          addressState
          addressZip
          addressCountry
          source
        }
      }
      """,
      expectedData: .containsKVPs([
        "email": request.email,
        "name": request.name,
        "requestedBooks": request.requestedBooks,
        "aboutRequester": request.aboutRequester,
        "addressStreet": request.addressStreet,
        "addressCity": request.addressCity,
        "addressState": request.addressState,
        "addressCountry": request.addressCountry,
        "source": request.source,
      ])
    ).run(self)
  }

  func testQueryFreeOrderWithStreet2() {
    let request = FreeOrderRequest.createFixture(on: app.db) {
      $0.addressStreet2 = "hey ho howdy"
    }

    GraphQLTest(
      """
      query {
        request: getFreeOrderRequest(id: "\(request.id!.uuidString)") {
          addressStreet2
        }
      }
      """,
      expectedData: .containsKVPs(["addressStreet2": "hey ho howdy"])
    ).run(self)
  }

  func testCreateFreeOrderRequest() throws {
    let request: Map = .dictionary([
      "email": "foo@bar.com",
      "requestedBooks": "La Senda Antigua",
      "aboutRequester": "not a freebie hunter",
      "name": "Bob",
      "addressStreet": "123 Magnolia Lane",
      "addressStreet2": "apt 2",
      "addressCity": "Beverly Hills",
      "addressState": "CA",
      "addressZip": "90210",
      "addressCountry": "US",
      "source": "https://zoecostarica.com",
    ])
    GraphQLTest(
      """
      mutation CreateFreeOrderRequest($input: CreateFreeOrderRequestInput!) {
        request: createFreeOrderRequest(input: $input) {
          email
          requestedBooks
          aboutRequester
          name
          addressStreet
          addressStreet2
          addressCity
          addressState
          addressZip
          addressCountry
          source
        }
      }
      """,
      expectedData: .containsKVPs([
        "email": "foo@bar.com",
        "requestedBooks": "La Senda Antigua",
        "aboutRequester": "not a freebie hunter",
        "name": "Bob",
        "addressStreet": "123 Magnolia Lane",
        "addressStreet2": "apt 2",
        "addressCity": "Beverly Hills",
        "addressState": "CA",
        "addressZip": "90210",
        "addressCountry": "US",
        "source": "https:\\/\\/zoecostarica.com",
      ])
    ).run(self, variables: ["input": request])
  }
}
