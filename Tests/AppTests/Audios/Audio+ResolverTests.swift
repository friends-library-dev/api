import XCTVapor
import XCTVaporUtils

@testable import App

final class AudioResolverTests: AppTestCase {

  func testCreateAudio() async throws {
    let entities = await Entities.create()
    _ = try await Current.db.delete(entities.audio.id)
    let audio = Audio.valid
    audio.editionId = entities.edition.id
    let map = audio.gqlMap()

    GraphQLTest(
      """
      mutation CreateAudio($input: CreateAudioInput!) {
        audio: createAudio(input: $input) {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": map["id"]]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": map])
  }

  func testGetAudio() async throws {
    let entities = await Entities.create()
    let audio = entities.audio

    GraphQLTest(
      """
      query GetAudio {
        audio: getAudio(id: "\(audio.id.uuidString)") {
          id
          files {
            podcast {
              hq {
                logPath
              }
            }
          }
        }
      }
      """,
      expectedData: .containsKVPs([
        "id": audio.id.lowercased,
        "logPath": DownloadableFile(
          edition: entities.edition,
          format: .audio(.podcast(.high))
        )
        .logPath
        .replacingOccurrences(of: "/", with: "\\/"),
      ]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app)
  }

  func testUpdateAudio() async throws {
    let audio = await Entities.create().audio

    // do some updates here ---vvv
    audio.reader = "new value"

    GraphQLTest(
      """
      mutation UpdateAudio($input: UpdateAudioInput!) {
        audio: updateAudio(input: $input) {
          reader
        }
      }
      """,
      expectedData: .containsKVPs(["reader": "new value"]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": audio.gqlMap()])
  }

  func testDeleteAudio() async throws {
    let audio = await Entities.create().audio

    GraphQLTest(
      """
      mutation DeleteAudio {
        audio: deleteAudio(id: "\(audio.id.uuidString)") {
          id
        }
      }
      """,
      expectedData: .containsKVPs(["id": audio.id.lowercased]),
      headers: [.authorization: "Bearer \(Seeded.tokens.allScopes)"]
    ).run(Self.app, variables: ["input": audio.gqlMap()])

    let retrieved = try? await Current.db.find(audio.id)
    XCTAssertNil(retrieved)
  }
}
