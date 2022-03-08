import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class FreeOrderRequestResolverTests: AppTestCase {

  func testQueryFreeOrder() async throws {
    let request = try await Current.db.create(FreeOrderRequest.mock)

    GraphQLTest(
      """
      query {
        request: getFreeOrderRequest(id: "\(request.id.uuidString)") {
          email
          name
          requestedBooks
          aboutRequester
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
    ).run(Self.app)
  }

  func testQueryFreeOrderWithStreet2() async throws {
    let request: FreeOrderRequest = .mock
    request.addressStreet2 = "hey ho howdy"
    try await Current.db.create(request)

    GraphQLTest(
      """
      query {
        request: getFreeOrderRequest(id: "\(request.id.uuidString)") {
          addressStreet2
        }
      }
      """,
      expectedData: .containsKVPs(["addressStreet2": "hey ho howdy"])
    ).run(Self.app)
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
          id
        }
      }
      """,
      expectedData: .contains("\"id\":")
    ).run(Self.app, variables: ["input": request])
  }
}
