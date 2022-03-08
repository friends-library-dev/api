import Vapor

// below auto-generated

extension Resolver {
  func getEditionImpression(
    req: Req,
    args: IdentifyEntity
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .queryEntities)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.find(EditionImpression.self, byId: args.id)
    }
  }

  func getEditionImpressions(req: Req, args: NoArgs) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.query(EditionImpression.self).all()
    }
  }

  func createEditionImpression(
    req: Req,
    args: InputArgs<AppSchema.CreateEditionImpressionInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(EditionImpression(args.input)).identity
    }
  }

  func createEditionImpressions(
    req: Req,
    args: InputArgs<[AppSchema.CreateEditionImpressionInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(EditionImpression.init)).map(\.identity)
    }
  }

  func updateEditionImpression(
    req: Req,
    args: InputArgs<AppSchema.UpdateEditionImpressionInput>
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.update(EditionImpression(args.input))
    }
  }

  func updateEditionImpressions(
    req: Req,
    args: InputArgs<[AppSchema.UpdateEditionImpressionInput]>
  ) throws -> Future<[EditionImpression]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionImpression].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(EditionImpression.init))
    }
  }

  func deleteEditionImpression(
    req: Req,
    args: IdentifyEntity
  ) throws -> Future<EditionImpression> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionImpression.self, on: req.eventLoop) {
      try await Current.db.delete(EditionImpression.self, byId: args.id)
    }
  }
}
