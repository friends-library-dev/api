import Vapor

// below auto-generated

extension Resolver {
  func getIsbn(req: Req, args: IdentifyEntity) throws -> Future<Isbn> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.find(Isbn.self, byId: args.id)
    }
  }

  func getIsbns(req: Req, args: NoArgs) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Isbn].self, on: req.eventLoop) {
      try await Current.db.query(Isbn.self).all()
    }
  }

  func createIsbn(
    req: Req,
    args: InputArgs<AppSchema.CreateIsbnInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(Isbn(args.input)).identity
    }
  }

  func createIsbns(
    req: Req,
    args: InputArgs<[AppSchema.CreateIsbnInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Isbn.init)).map(\.identity)
    }
  }

  func updateIsbn(
    req: Req,
    args: InputArgs<AppSchema.UpdateIsbnInput>
  ) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.update(Isbn(args.input))
    }
  }

  func updateIsbns(
    req: Req,
    args: InputArgs<[AppSchema.UpdateIsbnInput]>
  ) throws -> Future<[Isbn]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Isbn].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Isbn.init))
    }
  }

  func deleteIsbn(req: Req, args: IdentifyEntity) throws -> Future<Isbn> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Isbn.self, on: req.eventLoop) {
      try await Current.db.delete(Isbn.self, byId: args.id)
    }
  }
}
