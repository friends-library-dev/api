import Vapor

extension Resolver {
  struct GetTokenByValueArgs: Codable {
    let value: UUID
  }

  func getTokenByValue(req: Req, args: GetTokenByValueArgs) throws -> Future<Token> {
    future(of: Token.self, on: req.eventLoop) {
      try await Current.db.query(Token.self)
        .where(.value == args.value)
        .first()
    }
  }
}

// below auto-generated

extension Resolver {
  func getToken(req: Req, args: IdentifyEntity) throws -> Future<Token> {
    try req.requirePermission(to: .queryTokens)
    return future(of: Token.self, on: req.eventLoop) {
      try await Current.db.find(Token.self, byId: args.id)
    }
  }

  func getTokens(req: Req, args: NoArgs) throws -> Future<[Token]> {
    try req.requirePermission(to: .queryTokens)
    return future(of: [Token].self, on: req.eventLoop) {
      try await Current.db.query(Token.self).all()
    }
  }

  func createToken(
    req: Req,
    args: InputArgs<AppSchema.CreateTokenInput>
  ) throws -> Future<IdentifyEntity> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: IdentifyEntity.self, on: req.eventLoop) {
      try await Current.db.create(Token(args.input)).identity
    }
  }

  func createTokens(
    req: Req,
    args: InputArgs<[AppSchema.CreateTokenInput]>
  ) throws -> Future<[IdentifyEntity]> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: [IdentifyEntity].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Token.init)).map(\.identity)
    }
  }

  func updateToken(
    req: Req,
    args: InputArgs<AppSchema.UpdateTokenInput>
  ) throws -> Future<Token> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: Token.self, on: req.eventLoop) {
      try await Current.db.update(Token(args.input))
    }
  }

  func updateTokens(
    req: Req,
    args: InputArgs<[AppSchema.UpdateTokenInput]>
  ) throws -> Future<[Token]> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: [Token].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Token.init))
    }
  }

  func deleteToken(req: Req, args: IdentifyEntity) throws -> Future<Token> {
    try req.requirePermission(to: .mutateTokens)
    return future(of: Token.self, on: req.eventLoop) {
      try await Current.db.delete(Token.self, byId: args.id)
    }
  }
}
