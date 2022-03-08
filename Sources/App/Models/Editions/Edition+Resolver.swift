import Graphiti
import Vapor

extension Resolver {
  func deleteEditionEditionChapters(
    req: Req,
    args: IdentifyEntity
  ) throws -> Future<[EditionChapter]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [EditionChapter].self, on: req.eventLoop) {
      return try await Current.db.query(EditionChapter.self)
        .where(.editionId == args.id)
        .delete()
    }
  }

  func createEdition(
    req: Req,
    args: InputArgs<AppSchema.CreateEditionInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      let isbn: Isbn
      do {
        isbn = try await Current.db.query(Isbn.self)
          .where(.isNull(.editionId))
          .first()
      } catch {
        await slackError("Failed to query ISBN to assign to new edition: \(error)")
        throw error
      }

      let edition = try await Current.db.create(Edition(args.input))
      isbn.editionId = edition.id
      try await Current.db.update(isbn)
      return edition.identity
    }
  }
}

extension AppSchema {
  static var deleteEditionEditionChapters: AppField<[EditionChapter], IdentifyEntity> {
    Field("deleteEditionEditionChapters", at: Resolver.deleteEditionEditionChapters) {
      Argument("id", at: \.id)
    }
  }
}

// below auto-generated

extension Resolver {
  func getEdition(req: Req, args: IdentifyEntity) throws -> Future<Edition> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.find(Edition.self, byId: args.id)
    }
  }

  func getEditions(req: Req, args: NoArgs) throws -> Future<[Edition]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Edition].self, on: req.eventLoop) {
      try await Current.db.query(Edition.self).all()
    }
  }

  func createEditions(
    req: Req,
    args: InputArgs<[AppSchema.CreateEditionInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Edition.init)).map(\.identity)
    }
  }

  func updateEdition(
    req: Req,
    args: InputArgs<AppSchema.UpdateEditionInput>
  ) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.update(Edition(args.input))
    }
  }

  func updateEditions(
    req: Req,
    args: InputArgs<[AppSchema.UpdateEditionInput]>
  ) throws -> Future<[Edition]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Edition].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Edition.init))
    }
  }

  func deleteEdition(req: Req, args: IdentifyEntity) throws -> Future<Edition> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Edition.self, on: req.eventLoop) {
      try await Current.db.delete(Edition.self, byId: args.id)
    }
  }
}
