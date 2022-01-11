// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var EditionChapterType: AppType<EditionChapter> {
    Type(EditionChapter.self) {
      Field("id", at: \.id.rawValue)
      Field("editionId", at: \.editionId.rawValue)
      Field("order", at: \.order)
      Field("shortHeading", at: \.shortHeading)
      Field("isIntermediateTitle", at: \.isIntermediateTitle)
      Field("customId", at: \.customId)
      Field("sequenceNumber", at: \.sequenceNumber)
      Field("nonSequenceTitle", at: \.nonSequenceTitle)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("edition", with: \.edition)
    }
  }

  struct CreateEditionChapterInput: Codable {
    let id: UUID?
    let editionId: UUID
    let order: Int
    let shortHeading: String
    let isIntermediateTitle: Bool
    let customId: String?
    let sequenceNumber: Int?
    let nonSequenceTitle: String?
  }

  struct UpdateEditionChapterInput: Codable {
    let id: UUID
    let editionId: UUID
    let order: Int
    let shortHeading: String
    let isIntermediateTitle: Bool
    let customId: String?
    let sequenceNumber: Int?
    let nonSequenceTitle: String?
  }

  struct CreateEditionChapterArgs: Codable {
    let input: AppSchema.CreateEditionChapterInput
  }

  struct UpdateEditionChapterArgs: Codable {
    let input: AppSchema.UpdateEditionChapterInput
  }

  struct CreateEditionChaptersArgs: Codable {
    let input: [AppSchema.CreateEditionChapterInput]
  }

  struct UpdateEditionChaptersArgs: Codable {
    let input: [AppSchema.UpdateEditionChapterInput]
  }

  static var CreateEditionChapterInputType: AppInput<AppSchema.CreateEditionChapterInput> {
    Input(AppSchema.CreateEditionChapterInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("order", at: \.order)
      InputField("shortHeading", at: \.shortHeading)
      InputField("isIntermediateTitle", at: \.isIntermediateTitle)
      InputField("customId", at: \.customId)
      InputField("sequenceNumber", at: \.sequenceNumber)
      InputField("nonSequenceTitle", at: \.nonSequenceTitle)
    }
  }

  static var UpdateEditionChapterInputType: AppInput<AppSchema.UpdateEditionChapterInput> {
    Input(AppSchema.UpdateEditionChapterInput.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("order", at: \.order)
      InputField("shortHeading", at: \.shortHeading)
      InputField("isIntermediateTitle", at: \.isIntermediateTitle)
      InputField("customId", at: \.customId)
      InputField("sequenceNumber", at: \.sequenceNumber)
      InputField("nonSequenceTitle", at: \.nonSequenceTitle)
    }
  }

  static var getEditionChapter: AppField<EditionChapter, IdentifyEntityArgs> {
    Field("getEditionChapter", at: Resolver.getEditionChapter) {
      Argument("id", at: \.id)
    }
  }

  static var getEditionChapters: AppField<[EditionChapter], NoArgs> {
    Field("getEditionChapters", at: Resolver.getEditionChapters)
  }

  static var createEditionChapter: AppField<EditionChapter, AppSchema.CreateEditionChapterArgs> {
    Field("createEditionChapter", at: Resolver.createEditionChapter) {
      Argument("input", at: \.input)
    }
  }

  static var createEditionChapters: AppField<[EditionChapter], AppSchema.CreateEditionChaptersArgs> {
    Field("createEditionChapters", at: Resolver.createEditionChapters) {
      Argument("input", at: \.input)
    }
  }

  static var updateEditionChapter: AppField<EditionChapter, AppSchema.UpdateEditionChapterArgs> {
    Field("updateEditionChapter", at: Resolver.updateEditionChapter) {
      Argument("input", at: \.input)
    }
  }

  static var updateEditionChapters: AppField<[EditionChapter], AppSchema.UpdateEditionChaptersArgs> {
    Field("updateEditionChapters", at: Resolver.updateEditionChapters) {
      Argument("input", at: \.input)
    }
  }

  static var deleteEditionChapter: AppField<EditionChapter, IdentifyEntityArgs> {
    Field("deleteEditionChapter", at: Resolver.deleteEditionChapter) {
      Argument("id", at: \.id)
    }
  }
}

extension EditionChapter {
  convenience init(_ input: AppSchema.CreateEditionChapterInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      editionId: .init(rawValue: input.editionId),
      order: input.order,
      shortHeading: input.shortHeading,
      isIntermediateTitle: input.isIntermediateTitle,
      customId: input.customId,
      sequenceNumber: input.sequenceNumber,
      nonSequenceTitle: input.nonSequenceTitle
    )
  }

  convenience init(_ input: AppSchema.UpdateEditionChapterInput) {
    self.init(
      id: .init(rawValue: input.id),
      editionId: .init(rawValue: input.editionId),
      order: input.order,
      shortHeading: input.shortHeading,
      isIntermediateTitle: input.isIntermediateTitle,
      customId: input.customId,
      sequenceNumber: input.sequenceNumber,
      nonSequenceTitle: input.nonSequenceTitle
    )
  }

  func update(_ input: AppSchema.UpdateEditionChapterInput) {
    editionId = .init(rawValue: input.editionId)
    order = input.order
    shortHeading = input.shortHeading
    isIntermediateTitle = input.isIntermediateTitle
    customId = input.customId
    sequenceNumber = input.sequenceNumber
    nonSequenceTitle = input.nonSequenceTitle
    updatedAt = Current.date()
  }
}
