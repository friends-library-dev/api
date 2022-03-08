import Vapor

// below auto-generated

extension Resolver {
  func getAudio(req: Req, args: IdentifyEntity) throws -> Future<Audio> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.find(Audio.self, byId: args.id)
    }
  }

  func getAudios(req: Req, args: NoArgs) throws -> Future<[Audio]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.query(Audio.self).all()
    }
  }

  func createAudio(
    req: Req,
    args: InputArgs<AppSchema.CreateAudioInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(Audio(args.input)).identity
    }
  }

  func createAudios(
    req: Req,
    args: InputArgs<[AppSchema.CreateAudioInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Audio.init)).map(\.identity)
    }
  }

  func updateAudio(
    req: Req,
    args: InputArgs<AppSchema.UpdateAudioInput>
  ) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.update(Audio(args.input))
    }
  }

  func updateAudios(
    req: Req,
    args: InputArgs<[AppSchema.UpdateAudioInput]>
  ) throws -> Future<[Audio]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Audio].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Audio.init))
    }
  }

  func deleteAudio(req: Req, args: IdentifyEntity) throws -> Future<Audio> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Audio.self, on: req.eventLoop) {
      try await Current.db.delete(Audio.self, byId: args.id)
    }
  }
}
