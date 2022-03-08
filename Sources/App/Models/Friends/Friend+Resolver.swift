import Vapor

// below auto-generated

extension Resolver {
  func getFriend(req: Req, args: IdentifyEntity) throws -> Future<Friend> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.find(Friend.self, byId: args.id)
    }
  }

  func getFriends(req: Req, args: NoArgs) throws -> Future<[Friend]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.query(Friend.self).all()
    }
  }

  func createFriend(
    req: Req,
    args: InputArgs<AppSchema.CreateFriendInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(Friend(args.input)).identity
    }
  }

  func createFriends(
    req: Req,
    args: InputArgs<[AppSchema.CreateFriendInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Friend.init)).map(\.identity)
    }
  }

  func updateFriend(
    req: Req,
    args: InputArgs<AppSchema.UpdateFriendInput>
  ) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.update(Friend(args.input))
    }
  }

  func updateFriends(
    req: Req,
    args: InputArgs<[AppSchema.UpdateFriendInput]>
  ) throws -> Future<[Friend]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Friend].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Friend.init))
    }
  }

  func deleteFriend(req: Req, args: IdentifyEntity) throws -> Future<Friend> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Friend.self, on: req.eventLoop) {
      try await Current.db.delete(Friend.self, byId: args.id)
    }
  }
}
