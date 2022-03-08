import Vapor

extension Resolver {
  func getLatestArtifactProductionVersion(
    req: Req,
    args: NoArgs
  ) throws -> Future<ArtifactProductionVersion> {
    future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.query(ArtifactProductionVersion.self)
        .orderBy(.createdAt, .desc)
        .first()
    }
  }
}

// below auto-generated

extension Resolver {
  func getArtifactProductionVersion(
    req: Req,
    args: IdentifyEntity
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .queryArtifactProductionVersions)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.find(ArtifactProductionVersion.self, byId: args.id)
    }
  }

  func getArtifactProductionVersions(
    req: Req,
    args: NoArgs
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .queryArtifactProductionVersions)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.query(ArtifactProductionVersion.self).all()
    }
  }

  func createArtifactProductionVersion(
    req: Req,
    args: InputArgs<AppSchema.CreateArtifactProductionVersionInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(ArtifactProductionVersion(args.input)).identity
    }
  }

  func createArtifactProductionVersions(
    req: Req,
    args: InputArgs<[AppSchema.CreateArtifactProductionVersionInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(ArtifactProductionVersion.init)).map(\.identity)
    }
  }

  func updateArtifactProductionVersion(
    req: Req,
    args: InputArgs<AppSchema.UpdateArtifactProductionVersionInput>
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.update(ArtifactProductionVersion(args.input))
    }
  }

  func updateArtifactProductionVersions(
    req: Req,
    args: InputArgs<[AppSchema.UpdateArtifactProductionVersionInput]>
  ) throws -> Future<[ArtifactProductionVersion]> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    return future(of: [ArtifactProductionVersion].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(ArtifactProductionVersion.init))
    }
  }

  func deleteArtifactProductionVersion(
    req: Req,
    args: IdentifyEntity
  ) throws -> Future<ArtifactProductionVersion> {
    try req.requirePermission(to: .mutateArtifactProductionVersions)
    return future(of: ArtifactProductionVersion.self, on: req.eventLoop) {
      try await Current.db.delete(ArtifactProductionVersion.self, byId: args.id)
    }
  }
}
