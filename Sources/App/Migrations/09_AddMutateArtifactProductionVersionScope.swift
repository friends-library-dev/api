import Fluent
import Vapor

struct AddMutateArtifactProductionVersionScope: Migration {

  func prepare(on database: Database) -> Future<Void> {
    database.enum(TokenScope.M5.dbEnumName)
      .case(TokenScope.M9.Scope.mutateArtifactProductionVersions)
      .update()
      .transform(to: ())
  }

  func revert(on database: Database) -> Future<Void> {
    database.enum(TokenScope.M5.dbEnumName)
      .deleteCase(TokenScope.M9.Scope.mutateArtifactProductionVersions)
      .update()
      .transform(to: ())
  }
}
