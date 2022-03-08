import Vapor

// below auto-generated

extension Resolver {
  func getAudioPart(req: Req, args: IdentifyEntity) throws -> Future<AudioPart> {
    try req.requirePermission(to: .queryEntities)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.find(AudioPart.self, byId: args.id)
    }
  }

  func getAudioParts(req: Req, args: NoArgs) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.query(AudioPart.self).all()
    }
  }

  func createAudioPart(
    req: Req,
    args: InputArgs<AppSchema.CreateAudioPartInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(AudioPart(args.input)).identity
    }
  }

  func createAudioParts(
    req: Req,
    args: InputArgs<[AppSchema.CreateAudioPartInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(AudioPart.init)).map(\.identity)
    }
  }

  func updateAudioPart(
    req: Req,
    args: InputArgs<AppSchema.UpdateAudioPartInput>
  ) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.update(AudioPart(args.input))
    }
  }

  func updateAudioParts(
    req: Req,
    args: InputArgs<[AppSchema.UpdateAudioPartInput]>
  ) throws -> Future<[AudioPart]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [AudioPart].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(AudioPart.init))
    }
  }

  func deleteAudioPart(req: Req, args: IdentifyEntity) throws -> Future<AudioPart> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: AudioPart.self, on: req.eventLoop) {
      try await Current.db.delete(AudioPart.self, byId: args.id)
    }
  }
}
