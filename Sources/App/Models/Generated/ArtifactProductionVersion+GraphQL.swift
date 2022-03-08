// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var ArtifactProductionVersionType: ModelType<ArtifactProductionVersion> {
    Type(ArtifactProductionVersion.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("version", at: \.version.rawValue)
      Field("createdAt", at: \.createdAt)
    }
  }

  struct CreateArtifactProductionVersionInput: Codable {
    let id: UUID?
    let version: String
  }

  struct UpdateArtifactProductionVersionInput: Codable {
    let id: UUID
    let version: String
  }

  static var CreateArtifactProductionVersionInputType: AppInput<
    AppSchema
      .CreateArtifactProductionVersionInput
  > {
    Input(AppSchema.CreateArtifactProductionVersionInput.self) {
      InputField("id", at: \.id)
      InputField("version", at: \.version)
    }
  }

  static var UpdateArtifactProductionVersionInputType: AppInput<
    AppSchema
      .UpdateArtifactProductionVersionInput
  > {
    Input(AppSchema.UpdateArtifactProductionVersionInput.self) {
      InputField("id", at: \.id)
      InputField("version", at: \.version)
    }
  }

  static var getArtifactProductionVersion: AppField<ArtifactProductionVersion, IdentifyEntity> {
    Field("getArtifactProductionVersion", at: Resolver.getArtifactProductionVersion) {
      Argument("id", at: \.id)
    }
  }

  static var getArtifactProductionVersions: AppField<[ArtifactProductionVersion], NoArgs> {
    Field("getArtifactProductionVersions", at: Resolver.getArtifactProductionVersions)
  }

  static var createArtifactProductionVersion: AppField<
    IdentifyEntity,
    InputArgs<CreateArtifactProductionVersionInput>
  > {
    Field("createArtifactProductionVersion", at: Resolver.createArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var createArtifactProductionVersions: AppField<
    [IdentifyEntity],
    InputArgs<[CreateArtifactProductionVersionInput]>
  > {
    Field("createArtifactProductionVersions", at: Resolver.createArtifactProductionVersions) {
      Argument("input", at: \.input)
    }
  }

  static var updateArtifactProductionVersion: AppField<
    ArtifactProductionVersion,
    InputArgs<UpdateArtifactProductionVersionInput>
  > {
    Field("updateArtifactProductionVersion", at: Resolver.updateArtifactProductionVersion) {
      Argument("input", at: \.input)
    }
  }

  static var updateArtifactProductionVersions: AppField<
    [ArtifactProductionVersion],
    InputArgs<[UpdateArtifactProductionVersionInput]>
  > {
    Field("updateArtifactProductionVersions", at: Resolver.updateArtifactProductionVersions) {
      Argument("input", at: \.input)
    }
  }

  static var deleteArtifactProductionVersion: AppField<ArtifactProductionVersion, IdentifyEntity> {
    Field("deleteArtifactProductionVersion", at: Resolver.deleteArtifactProductionVersion) {
      Argument("id", at: \.id)
    }
  }
}

extension ArtifactProductionVersion {
  convenience init(_ input: AppSchema.CreateArtifactProductionVersionInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      version: .init(rawValue: input.version)
    )
  }

  convenience init(_ input: AppSchema.UpdateArtifactProductionVersionInput) {
    self.init(
      id: .init(rawValue: input.id),
      version: .init(rawValue: input.version)
    )
  }

  func update(_ input: AppSchema.UpdateArtifactProductionVersionInput) {
    version = .init(rawValue: input.version)
  }
}
