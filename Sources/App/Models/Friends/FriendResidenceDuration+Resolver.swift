import Vapor

// below auto-generated

extension Resolver {
  func getFriendResidenceDuration(
    req: Req,
    args: IdentifyEntity
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .queryEntities)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.find(FriendResidenceDuration.self, byId: args.id)
    }
  }

  func getFriendResidenceDurations(
    req: Req,
    args: NoArgs
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.query(FriendResidenceDuration.self).all()
    }
  }

  func createFriendResidenceDuration(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendResidenceDurationInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(FriendResidenceDuration(args.input)).identity
    }
  }

  func createFriendResidenceDurations(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendResidenceDurationInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(FriendResidenceDuration.init)).map(\.identity)
    }
  }

  func updateFriendResidenceDuration(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendResidenceDurationInput>
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.update(FriendResidenceDuration(args.input))
    }
  }

  func updateFriendResidenceDurations(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendResidenceDurationInput]>
  ) throws -> Future<[FriendResidenceDuration]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [FriendResidenceDuration].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(FriendResidenceDuration.init))
    }
  }

  func deleteFriendResidenceDuration(
    req: Req,
    args: IdentifyEntity
  ) throws -> Future<FriendResidenceDuration> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: FriendResidenceDuration.self, on: req.eventLoop) {
      try await Current.db.delete(FriendResidenceDuration.self, byId: args.id)
    }
  }
}
