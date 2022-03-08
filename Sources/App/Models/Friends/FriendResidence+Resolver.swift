import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidence(req: Req, args: IdentifyEntity) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .queryEntities)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.find(FriendResidence.self, byId: args.id)
    }
  }

  func getFriendResidences(req: Req, args: NoArgs) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.query(FriendResidence.self).all()
    }
  }

  func createFriendResidence(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendResidenceInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(FriendResidence(args.input)).identity
    }
  }

  func createFriendResidences(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendResidenceInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(FriendResidence.init)).map(\.identity)
    }
  }

  func updateFriendResidence(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendResidenceInput>
  ) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.update(FriendResidence(args.input))
    }
  }

  func updateFriendResidences(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendResidenceInput]>
  ) throws -> Future<[FriendResidence]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendResidence].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(FriendResidence.init))
    }
  }

  func deleteFriendResidence(req: Req, args: IdentifyEntity) throws -> Future<FriendResidence> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidence.self, on: req.eventLoop) {
      try await Current.db.delete(FriendResidence.self, byId: args.id)
    }
  }
}
