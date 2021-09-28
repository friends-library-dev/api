import Fluent
import Foundation
import Graphiti
import Vapor

extension Resolver {

  struct CreateArtifactProductionVersionArgs: Codable {
    let revision: String
  }

  func createArtifactProductionVersion(
    request: Request,
    args: CreateArtifactProductionVersionArgs
  ) throws -> Future<ArtifactProductionVersion> {
    try request.requirePermission(to: .mutateArtifactProductionVersions)
    let version = ArtifactProductionVersion(version: args.revision)
    return version.create(on: request.db).map { version }
  }

  func getLatestArtifactProductionVersion(
    request: Request,
    args: NoArguments
  ) throws -> Future<ArtifactProductionVersion> {
    ArtifactProductionVersion.query(on: request.db)
      .sort(\.$createdAt, .descending)
      .first()
      .unwrap(or: Abort(.notFound))
  }
}
