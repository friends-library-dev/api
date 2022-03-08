import Vapor

// below auto-generated

extension Resolver {
  func getDocument(req: Req, args: IdentifyEntity) throws -> Future<Document> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.find(Document.self, byId: args.id)
    }
  }

  func getDocuments(req: Req, args: NoArgs) throws -> Future<[Document]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Document].self, on: req.eventLoop) {
      try await Current.db.query(Document.self).all()
    }
  }

  func createDocument(
    req: Req,
    args: InputArgs<AppSchema.CreateDocumentInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(Document(args.input)).identity
    }
  }

  func createDocuments(
    req: Req,
    args: InputArgs<[AppSchema.CreateDocumentInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Document.init)).map(\.identity)
    }
  }

  func updateDocument(
    req: Req,
    args: InputArgs<AppSchema.UpdateDocumentInput>
  ) throws -> Future<Document> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.update(Document(args.input))
    }
  }

  func updateDocuments(
    req: Req,
    args: InputArgs<[AppSchema.UpdateDocumentInput]>
  ) throws -> Future<[Document]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Document].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Document.init))
    }
  }

  func deleteDocument(req: Req, args: IdentifyEntity) throws -> Future<Document> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.delete(Document.self, byId: args.id)
    }
  }
}
