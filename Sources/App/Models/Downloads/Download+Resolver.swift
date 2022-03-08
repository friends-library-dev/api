import Vapor

// below auto-generated

extension Resolver {
  func getDownload(req: Req, args: IdentifyEntity) throws -> Future<Download> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.find(Download.self, byId: args.id)
    }
  }

  func getDownloads(req: Req, args: NoArgs) throws -> Future<[Download]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.query(Download.self).all()
    }
  }

  func createDownload(
    req: Req,
    args: InputArgs<AppSchema.CreateDownloadInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(Download(args.input)).identity
    }
  }

  func createDownloads(
    req: Req,
    args: InputArgs<[AppSchema.CreateDownloadInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Download.init)).map(\.identity)
    }
  }

  func updateDownload(
    req: Req,
    args: InputArgs<AppSchema.UpdateDownloadInput>
  ) throws -> Future<Download> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.update(Download(args.input))
    }
  }

  func updateDownloads(
    req: Req,
    args: InputArgs<[AppSchema.UpdateDownloadInput]>
  ) throws -> Future<[Download]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Download].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Download.init))
    }
  }

  func deleteDownload(req: Req, args: IdentifyEntity) throws -> Future<Download> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Download.self, on: req.eventLoop) {
      try await Current.db.delete(Download.self, byId: args.id)
    }
  }
}
