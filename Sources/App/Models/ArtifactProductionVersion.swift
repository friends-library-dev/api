import Fluent
import Vapor

final class ArtifactProductionVersion: Model, Content {
  static let schema = M8.tableName

  @ID(key: .id)
  var id: UUID?

  @Field(key: M8.version)
  var version: String

  @Timestamp(key: FieldKey.createdAt, on: .create)
  var createdAt: Date?

  init() {}

  init(id: UUID? = nil, version: String) {
    self.id = id
    self.version = version
  }
}

extension ArtifactProductionVersion {
  enum M8 {
    static let tableName = "artifact_production_versions"
    static let version = FieldKey("version")
  }
}
