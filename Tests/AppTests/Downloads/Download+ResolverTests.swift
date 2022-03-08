import GraphQL
import XCTVapor
import XCTVaporUtils

@testable import App

final class DownloadResolverTests: AppTestCase {

  func testCreateDownload() async throws {
    let entities = await Entities.create()
    let insert: Download = .random
    insert.audioQuality = .lq
    insert.audioPartNumber = 33
    insert.editionId = entities.edition.id
    let map = insert.gqlMap()

    GraphQLTest(
      """
      mutation CreateDownload($input: CreateDownloadInput!) {
        download: createDownload(input: $input) {
          id
        }
      }
      """,
      expectedData: .contains("\"id\":"),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": insert.gqlMap()])
  }
}
