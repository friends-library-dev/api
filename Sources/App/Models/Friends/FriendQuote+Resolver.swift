import Vapor

// below auto-generated

extension Resolver {
  func getFriendQuote(req: Req, args: IdentifyEntity) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .queryEntities)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.find(FriendQuote.self, byId: args.id)
    }
  }

  func getFriendQuotes(req: Req, args: NoArgs) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      try await Current.db.query(FriendQuote.self).all()
    }
  }

  func createFriendQuote(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendQuoteInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(FriendQuote(args.input)).identity
    }
  }

  func createFriendQuotes(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendQuoteInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(FriendQuote.init)).map(\.identity)
    }
  }

  func updateFriendQuote(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendQuoteInput>
  ) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.update(FriendQuote(args.input))
    }
  }

  func updateFriendQuotes(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendQuoteInput]>
  ) throws -> Future<[FriendQuote]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendQuote].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(FriendQuote.init))
    }
  }

  func deleteFriendQuote(req: Req, args: IdentifyEntity) throws -> Future<FriendQuote> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendQuote.self, on: req.eventLoop) {
      try await Current.db.delete(FriendQuote.self, byId: args.id)
    }
  }
}
