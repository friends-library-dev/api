import Vapor

// below auto-generated

extension Resolver {
  func getRelatedDocument(req: Req, args: IdentifyEntity) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .queryEntities)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.find(RelatedDocument.self, byId: args.id)
    }
  }

  func getRelatedDocuments(req: Req, args: NoArgs) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.query(RelatedDocument.self).all()
    }
  }

  func createRelatedDocument(
    req: Req,
    args: InputArgs<AppSchema.CreateRelatedDocumentInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(RelatedDocument(args.input)).identity
    }
  }

  func createRelatedDocuments(
    req: Req,
    args: InputArgs<[AppSchema.CreateRelatedDocumentInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(RelatedDocument.init)).map(\.identity)
    }
  }

  func updateRelatedDocument(
    req: Req,
    args: InputArgs<AppSchema.UpdateRelatedDocumentInput>
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.update(RelatedDocument(args.input))
    }
  }

  func updateRelatedDocuments(
    req: Req,
    args: InputArgs<[AppSchema.UpdateRelatedDocumentInput]>
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(RelatedDocument.init))
    }
  }

  func deleteRelatedDocument(req: Req, args: IdentifyEntity) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.delete(RelatedDocument.self, byId: args.id)
    }
  }
}
