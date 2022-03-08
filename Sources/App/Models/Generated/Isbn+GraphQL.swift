// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var IsbnType: ModelType<Isbn> {
    Type(Isbn.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("code", at: \.code.rawValue)
      Field("editionId", at: \.editionId?.rawValue.lowercased)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("edition", with: \.edition)
    }
  }

  struct CreateIsbnInput: Codable {
    let id: UUID?
    let code: String
    let editionId: UUID?
  }

  struct UpdateIsbnInput: Codable {
    let id: UUID
    let code: String
    let editionId: UUID?
  }

  static var CreateIsbnInputType: AppInput<AppSchema.CreateIsbnInput> {
    Input(AppSchema.CreateIsbnInput.self) {
      InputField("id", at: \.id)
      InputField("code", at: \.code)
      InputField("editionId", at: \.editionId)
    }
  }

  static var UpdateIsbnInputType: AppInput<AppSchema.UpdateIsbnInput> {
    Input(AppSchema.UpdateIsbnInput.self) {
      InputField("id", at: \.id)
      InputField("code", at: \.code)
      InputField("editionId", at: \.editionId)
    }
  }

  static var getIsbn: AppField<Isbn, IdentifyEntity> {
    Field("getIsbn", at: Resolver.getIsbn) {
      Argument("id", at: \.id)
    }
  }

  static var getIsbns: AppField<[Isbn], NoArgs> {
    Field("getIsbns", at: Resolver.getIsbns)
  }

  static var createIsbn: AppField<IdentifyEntity, InputArgs<CreateIsbnInput>> {
    Field("createIsbn", at: Resolver.createIsbn) {
      Argument("input", at: \.input)
    }
  }

  static var createIsbns: AppField<[IdentifyEntity], InputArgs<[CreateIsbnInput]>> {
    Field("createIsbns", at: Resolver.createIsbns) {
      Argument("input", at: \.input)
    }
  }

  static var updateIsbn: AppField<Isbn, InputArgs<UpdateIsbnInput>> {
    Field("updateIsbn", at: Resolver.updateIsbn) {
      Argument("input", at: \.input)
    }
  }

  static var updateIsbns: AppField<[Isbn], InputArgs<[UpdateIsbnInput]>> {
    Field("updateIsbns", at: Resolver.updateIsbns) {
      Argument("input", at: \.input)
    }
  }

  static var deleteIsbn: AppField<Isbn, IdentifyEntity> {
    Field("deleteIsbn", at: Resolver.deleteIsbn) {
      Argument("id", at: \.id)
    }
  }
}

extension Isbn {
  convenience init(_ input: AppSchema.CreateIsbnInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      code: .init(rawValue: input.code),
      editionId: input.editionId != nil ? .init(rawValue: input.editionId!) : nil
    )
  }

  convenience init(_ input: AppSchema.UpdateIsbnInput) {
    self.init(
      id: .init(rawValue: input.id),
      code: .init(rawValue: input.code),
      editionId: input.editionId != nil ? .init(rawValue: input.editionId!) : nil
    )
  }

  func update(_ input: AppSchema.UpdateIsbnInput) {
    code = .init(rawValue: input.code)
    editionId = input.editionId != nil ? .init(rawValue: input.editionId!) : nil
    updatedAt = Current.date()
  }
}
