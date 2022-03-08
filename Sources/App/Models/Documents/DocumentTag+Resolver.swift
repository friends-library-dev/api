import Vapor

// below auto-generated

extension Resolver {
  func getDocumentTag(req: Req, args: IdentifyEntity) throws -> Future<DocumentTag> {
    try req.requirePermission(to: .queryEntities)
    return future(of: DocumentTag.self, on: req.eventLoop) {
      try await Current.db.find(DocumentTag.self, byId: args.id)
    }
  }

  func getDocumentTags(req: Req, args: NoArgs) throws -> Future<[DocumentTag]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [DocumentTag].self, on: req.eventLoop) {
      try await Current.db.query(DocumentTag.self).all()
    }
  }

  func createDocumentTag(
    req: Req,
    args: InputArgs<AppSchema.CreateDocumentTagInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(DocumentTag(args.input)).identity
    }
  }

  func createDocumentTags(
    req: Req,
    args: InputArgs<[AppSchema.CreateDocumentTagInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(DocumentTag.init)).map(\.identity)
    }
  }

  func updateDocumentTag(
    req: Req,
    args: InputArgs<AppSchema.UpdateDocumentTagInput>
  ) throws -> Future<DocumentTag> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: DocumentTag.self, on: req.eventLoop) {
      try await Current.db.update(DocumentTag(args.input))
    }
  }

  func updateDocumentTags(
    req: Req,
    args: InputArgs<[AppSchema.UpdateDocumentTagInput]>
  ) throws -> Future<[DocumentTag]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [DocumentTag].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(DocumentTag.init))
    }
  }

  func deleteDocumentTag(req: Req, args: IdentifyEntity) throws -> Future<DocumentTag> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: DocumentTag.self, on: req.eventLoop) {
      try await Current.db.delete(DocumentTag.self, byId: args.id)
    }
  }
}
