import Fluent
// import GraphQlKit
import XCTVapor
import XCTVaporUtils

@testable import App

final class ArtifactProductionVersionResolverTests: GraphQLTestCase {
  override func configureApp(_ app: Application) throws {
    return try configure(app)
  }

  func testGetLatestRevision() throws {
    let latest = ArtifactProductionVersion.createFixture(on: app.db)
    #if os(macOS)
      let older = ArtifactProductionVersion.createFixture(on: app.db)
      older.adjustTimestamp(.createdAt, .subtractingDays(3))
    #endif

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
        "id": latest.id!.uuidString,
        "sha": latest.version,
      ])
    ).run(self)
  }

  func testCreateArtifactProductionVersion() throws {
    let revision = UUID().uuidString

    GraphQLTest(
      """
      mutation CreateArtifactProductionVersion($revision: String!) {
        version: createArtifactProductionVersion(revision: $revision) {
          sha: version
        } 
      }
      """,
      expectedData: .containsKVPs(["sha": revision]),
      headers: [.authorization: "Bearer \(Seeded.tokens.mutateArtifactProductionVersions)"]
    ).run(self, variables: ["revision": .string(revision)])

    let version = try ArtifactProductionVersion.query(on: app.db)
      .filter(\.$version == revision)
      .first()
      .wait()

    XCTAssertNotNil(version)
  }
}
