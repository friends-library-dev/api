// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var TokenType: ModelType<Token> {
    Type(Token.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("value", at: \.value.rawValue.lowercased)
      Field("description", at: \.description)
      Field("uses", at: \.uses)
      Field("createdAt", at: \.createdAt)
      Field("scopes", with: \.scopes)
    }
  }

  struct CreateTokenInput: Codable {
    let id: UUID?
    let value: UUID
    let description: String
    let uses: Int?
  }

  struct UpdateTokenInput: Codable {
    let id: UUID
    let value: UUID
    let description: String
    let uses: Int?
  }

  static var CreateTokenInputType: AppInput<AppSchema.CreateTokenInput> {
    Input(AppSchema.CreateTokenInput.self) {
      InputField("id", at: \.id)
      InputField("value", at: \.value)
      InputField("description", at: \.description)
      InputField("uses", at: \.uses)
    }
  }

  static var UpdateTokenInputType: AppInput<AppSchema.UpdateTokenInput> {
    Input(AppSchema.UpdateTokenInput.self) {
      InputField("id", at: \.id)
      InputField("value", at: \.value)
      InputField("description", at: \.description)
      InputField("uses", at: \.uses)
    }
  }

  static var getToken: AppField<Token, IdentifyEntity> {
    Field("getToken", at: Resolver.getToken) {
      Argument("id", at: \.id)
    }
  }

  static var getTokens: AppField<[Token], NoArgs> {
    Field("getTokens", at: Resolver.getTokens)
  }

  static var createToken: AppField<IdentifyEntity, InputArgs<CreateTokenInput>> {
    Field("createToken", at: Resolver.createToken) {
      Argument("input", at: \.input)
    }
  }

  static var createTokens: AppField<[IdentifyEntity], InputArgs<[CreateTokenInput]>> {
    Field("createTokens", at: Resolver.createTokens) {
      Argument("input", at: \.input)
    }
  }

  static var updateToken: AppField<Token, InputArgs<UpdateTokenInput>> {
    Field("updateToken", at: Resolver.updateToken) {
      Argument("input", at: \.input)
    }
  }

  static var updateTokens: AppField<[Token], InputArgs<[UpdateTokenInput]>> {
    Field("updateTokens", at: Resolver.updateTokens) {
      Argument("input", at: \.input)
    }
  }

  static var deleteToken: AppField<Token, IdentifyEntity> {
    Field("deleteToken", at: Resolver.deleteToken) {
      Argument("id", at: \.id)
    }
  }
}

extension Token {
  convenience init(_ input: AppSchema.CreateTokenInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      value: .init(rawValue: input.value),
      description: input.description,
      uses: input.uses
    )
  }

  convenience init(_ input: AppSchema.UpdateTokenInput) {
    self.init(
      id: .init(rawValue: input.id),
      value: .init(rawValue: input.value),
      description: input.description,
      uses: input.uses
    )
  }

  func update(_ input: AppSchema.UpdateTokenInput) {
    value = .init(rawValue: input.value)
    description = input.description
    uses = input.uses
  }
}
