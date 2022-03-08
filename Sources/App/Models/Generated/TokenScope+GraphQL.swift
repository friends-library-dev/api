// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var TokenScopeType: ModelType<TokenScope> {
    Type(TokenScope.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("scope", at: \.scope)
      Field("tokenId", at: \.tokenId.rawValue.lowercased)
      Field("createdAt", at: \.createdAt)
      Field("token", with: \.token)
    }
  }

  struct CreateTokenScopeInput: Codable {
    let id: UUID?
    let scope: Scope
    let tokenId: UUID
  }

  struct UpdateTokenScopeInput: Codable {
    let id: UUID
    let scope: Scope
    let tokenId: UUID
  }

  static var CreateTokenScopeInputType: AppInput<AppSchema.CreateTokenScopeInput> {
    Input(AppSchema.CreateTokenScopeInput.self) {
      InputField("id", at: \.id)
      InputField("scope", at: \.scope)
      InputField("tokenId", at: \.tokenId)
    }
  }

  static var UpdateTokenScopeInputType: AppInput<AppSchema.UpdateTokenScopeInput> {
    Input(AppSchema.UpdateTokenScopeInput.self) {
      InputField("id", at: \.id)
      InputField("scope", at: \.scope)
      InputField("tokenId", at: \.tokenId)
    }
  }

  static var getTokenScope: AppField<TokenScope, IdentifyEntity> {
    Field("getTokenScope", at: Resolver.getTokenScope) {
      Argument("id", at: \.id)
    }
  }

  static var getTokenScopes: AppField<[TokenScope], NoArgs> {
    Field("getTokenScopes", at: Resolver.getTokenScopes)
  }

  static var createTokenScope: AppField<IdentifyEntity, InputArgs<CreateTokenScopeInput>> {
    Field("createTokenScope", at: Resolver.createTokenScope) {
      Argument("input", at: \.input)
    }
  }

  static var createTokenScopes: AppField<[IdentifyEntity], InputArgs<[CreateTokenScopeInput]>> {
    Field("createTokenScopes", at: Resolver.createTokenScopes) {
      Argument("input", at: \.input)
    }
  }

  static var updateTokenScope: AppField<TokenScope, InputArgs<UpdateTokenScopeInput>> {
    Field("updateTokenScope", at: Resolver.updateTokenScope) {
      Argument("input", at: \.input)
    }
  }

  static var updateTokenScopes: AppField<[TokenScope], InputArgs<[UpdateTokenScopeInput]>> {
    Field("updateTokenScopes", at: Resolver.updateTokenScopes) {
      Argument("input", at: \.input)
    }
  }

  static var deleteTokenScope: AppField<TokenScope, IdentifyEntity> {
    Field("deleteTokenScope", at: Resolver.deleteTokenScope) {
      Argument("id", at: \.id)
    }
  }
}

extension TokenScope {
  convenience init(_ input: AppSchema.CreateTokenScopeInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      tokenId: .init(rawValue: input.tokenId),
      scope: input.scope
    )
  }

  convenience init(_ input: AppSchema.UpdateTokenScopeInput) {
    self.init(
      id: .init(rawValue: input.id),
      tokenId: .init(rawValue: input.tokenId),
      scope: input.scope
    )
  }

  func update(_ input: AppSchema.UpdateTokenScopeInput) {
    scope = input.scope
    tokenId = .init(rawValue: input.tokenId)
  }
}
