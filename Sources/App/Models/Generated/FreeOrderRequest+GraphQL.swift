// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var FreeOrderRequestType: ModelType<FreeOrderRequest> {
    Type(FreeOrderRequest.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("name", at: \.name)
      Field("email", at: \.email.rawValue)
      Field("requestedBooks", at: \.requestedBooks)
      Field("aboutRequester", at: \.aboutRequester)
      Field("addressStreet", at: \.addressStreet)
      Field("addressStreet2", at: \.addressStreet2)
      Field("addressCity", at: \.addressCity)
      Field("addressState", at: \.addressState)
      Field("addressZip", at: \.addressZip)
      Field("addressCountry", at: \.addressCountry)
      Field("source", at: \.source)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("address", at: \.address)
    }
  }

  struct CreateFreeOrderRequestInput: Codable {
    let id: UUID?
    let name: String
    let email: String
    let requestedBooks: String
    let aboutRequester: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let source: String
  }

  struct UpdateFreeOrderRequestInput: Codable {
    let id: UUID
    let name: String
    let email: String
    let requestedBooks: String
    let aboutRequester: String
    let addressStreet: String
    let addressStreet2: String?
    let addressCity: String
    let addressState: String
    let addressZip: String
    let addressCountry: String
    let source: String
  }

  static var CreateFreeOrderRequestInputType: AppInput<AppSchema.CreateFreeOrderRequestInput> {
    Input(AppSchema.CreateFreeOrderRequestInput.self) {
      InputField("id", at: \.id)
      InputField("name", at: \.name)
      InputField("email", at: \.email)
      InputField("requestedBooks", at: \.requestedBooks)
      InputField("aboutRequester", at: \.aboutRequester)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("source", at: \.source)
    }
  }

  static var UpdateFreeOrderRequestInputType: AppInput<AppSchema.UpdateFreeOrderRequestInput> {
    Input(AppSchema.UpdateFreeOrderRequestInput.self) {
      InputField("id", at: \.id)
      InputField("name", at: \.name)
      InputField("email", at: \.email)
      InputField("requestedBooks", at: \.requestedBooks)
      InputField("aboutRequester", at: \.aboutRequester)
      InputField("addressStreet", at: \.addressStreet)
      InputField("addressStreet2", at: \.addressStreet2)
      InputField("addressCity", at: \.addressCity)
      InputField("addressState", at: \.addressState)
      InputField("addressZip", at: \.addressZip)
      InputField("addressCountry", at: \.addressCountry)
      InputField("source", at: \.source)
    }
  }

  static var getFreeOrderRequest: AppField<FreeOrderRequest, IdentifyEntity> {
    Field("getFreeOrderRequest", at: Resolver.getFreeOrderRequest) {
      Argument("id", at: \.id)
    }
  }

  static var getFreeOrderRequests: AppField<[FreeOrderRequest], NoArgs> {
    Field("getFreeOrderRequests", at: Resolver.getFreeOrderRequests)
  }

  static var createFreeOrderRequest: AppField<
    IdentifyEntity,
    InputArgs<CreateFreeOrderRequestInput>
  > {
    Field("createFreeOrderRequest", at: Resolver.createFreeOrderRequest) {
      Argument("input", at: \.input)
    }
  }

  static var createFreeOrderRequests: AppField<
    [IdentifyEntity],
    InputArgs<[CreateFreeOrderRequestInput]>
  > {
    Field("createFreeOrderRequests", at: Resolver.createFreeOrderRequests) {
      Argument("input", at: \.input)
    }
  }

  static var updateFreeOrderRequest: AppField<
    FreeOrderRequest,
    InputArgs<UpdateFreeOrderRequestInput>
  > {
    Field("updateFreeOrderRequest", at: Resolver.updateFreeOrderRequest) {
      Argument("input", at: \.input)
    }
  }

  static var updateFreeOrderRequests: AppField<
    [FreeOrderRequest],
    InputArgs<[UpdateFreeOrderRequestInput]>
  > {
    Field("updateFreeOrderRequests", at: Resolver.updateFreeOrderRequests) {
      Argument("input", at: \.input)
    }
  }

  static var deleteFreeOrderRequest: AppField<FreeOrderRequest, IdentifyEntity> {
    Field("deleteFreeOrderRequest", at: Resolver.deleteFreeOrderRequest) {
      Argument("id", at: \.id)
    }
  }
}

extension FreeOrderRequest {
  convenience init(_ input: AppSchema.CreateFreeOrderRequestInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      name: input.name,
      email: .init(rawValue: input.email),
      requestedBooks: input.requestedBooks,
      aboutRequester: input.aboutRequester,
      addressStreet: input.addressStreet,
      addressStreet2: input.addressStreet2,
      addressCity: input.addressCity,
      addressState: input.addressState,
      addressZip: input.addressZip,
      addressCountry: input.addressCountry,
      source: input.source
    )
  }

  convenience init(_ input: AppSchema.UpdateFreeOrderRequestInput) {
    self.init(
      id: .init(rawValue: input.id),
      name: input.name,
      email: .init(rawValue: input.email),
      requestedBooks: input.requestedBooks,
      aboutRequester: input.aboutRequester,
      addressStreet: input.addressStreet,
      addressStreet2: input.addressStreet2,
      addressCity: input.addressCity,
      addressState: input.addressState,
      addressZip: input.addressZip,
      addressCountry: input.addressCountry,
      source: input.source
    )
  }

  func update(_ input: AppSchema.UpdateFreeOrderRequestInput) {
    name = input.name
    email = .init(rawValue: input.email)
    requestedBooks = input.requestedBooks
    aboutRequester = input.aboutRequester
    addressStreet = input.addressStreet
    addressStreet2 = input.addressStreet2
    addressCity = input.addressCity
    addressState = input.addressState
    addressZip = input.addressZip
    addressCountry = input.addressCountry
    source = input.source
    updatedAt = Current.date()
  }
}
