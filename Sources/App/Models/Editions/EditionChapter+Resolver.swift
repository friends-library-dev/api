import Vapor

// below auto-generated

extension Resolver {
  func getEditionChapter(req: Req, args: IdentifyEntity) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .queryEntities)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.find(EditionChapter.self, byId: args.id)
    }
  }

  func getEditionChapters(req: Req, args: NoArgs) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.query(EditionChapter.self).all()
    }
  }

  func createEditionChapter(
    req: Req,
    args: InputArgs<AppSchema.CreateEditionChapterInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(EditionChapter(args.input)).identity
    }
  }

  func createEditionChapters(
    req: Req,
    args: InputArgs<[AppSchema.CreateEditionChapterInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(EditionChapter.init)).map(\.identity)
    }
  }

  func updateEditionChapter(
    req: Req,
    args: InputArgs<AppSchema.UpdateEditionChapterInput>
  ) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.update(EditionChapter(args.input))
    }
  }

  func updateEditionChapters(
    req: Req,
    args: InputArgs<[AppSchema.UpdateEditionChapterInput]>
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(EditionChapter.init))
    }
  }

  func deleteEditionChapter(req: Req, args: IdentifyEntity) throws -> Future<EditionChapter> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: EditionChapter.self, on: req.eventLoop) {
      try await Current.db.delete(EditionChapter.self, byId: args.id)
    }
  }
}
