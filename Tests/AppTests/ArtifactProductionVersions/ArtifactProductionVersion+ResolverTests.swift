import Fluent
import XCTVapor
import XCTVaporUtils

@testable import App

final class ArtifactProductionVersionResolverTests: AppTestCase {

  func testGetLatestRevision() async throws {
    let older = ArtifactProductionVersion.mockOld
    older.version = .init(rawValue: UUID().uuidString)
    try await Current.db.create(older)

    let latest = ArtifactProductionVersion.mock
    latest.version = .init(rawValue: UUID().uuidString)
    try await Current.db.create(latest)

    GraphQLTest(
      """
      query GetLatestArtifactProductionVersion {
        version: getLatestArtifactProductionVersion {
          id
          sha: version
        }
      }
      """,
      expectedData: .containsKVPs([
        "id": latest.id.lowercased,
        "sha": latest.version,
      ])
    ).run(Self.app)
  }

  func testCreateArtifactProductionVersion() throws {
    let revision = UUID().uuidString

    GraphQLTest(
      """
      mutation CreateArtifactProductionVersion($input: CreateArtifactProductionVersionInput!) {
        version: createArtifactProductionVersion(input: $input) {
          id
        }
      }
      """,
      expectedData: .contains("\"id\":"),
      headers: [.authorization: "Bearer \(Seeded.tokens.mutateArtifactProductionVersions)"]
    ).run(Self.app, variables: ["input": .dictionary(["version": .string(revision)])])
  }
}
