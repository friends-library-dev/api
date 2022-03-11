// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension AppSchema {
  static var AudioPartType: ModelType<AudioPart> {
    Type(AudioPart.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("audioId", at: \.audioId.rawValue.lowercased)
      Field("title", at: \.title)
      Field("duration", at: \.duration.rawValue)
      Field("chapters", at: \.chapters.rawValue)
      Field("order", at: \.order)
      Field("mp3SizeHq", at: \.mp3SizeHq.rawValue)
      Field("mp3SizeLq", at: \.mp3SizeLq.rawValue)
      Field("externalIdHq", at: \.externalIdHq.rawValue)
      Field("externalIdLq", at: \.externalIdLq.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("isPublished", at: \.isPublished)
      Field("mp3File", at: \.mp3File)
      Field("isValid", at: \.isValid)
      Field("audio", with: \.audio)
    }
  }

  struct CreateAudioPartInput: Codable {
    let id: UUID?
    let audioId: UUID
    let title: String
    let duration: Double
    let chapters: [Int]
    let order: Int
    let mp3SizeHq: Int
    let mp3SizeLq: Int
    let externalIdHq: Int64
    let externalIdLq: Int64
  }

  struct UpdateAudioPartInput: Codable {
    let id: UUID
    let audioId: UUID
    let title: String
    let duration: Double
    let chapters: [Int]
    let order: Int
    let mp3SizeHq: Int
    let mp3SizeLq: Int
    let externalIdHq: Int64
    let externalIdLq: Int64
  }

  static var CreateAudioPartInputType: AppInput<AppSchema.CreateAudioPartInput> {
    Input(AppSchema.CreateAudioPartInput.self) {
      InputField("id", at: \.id)
      InputField("audioId", at: \.audioId)
      InputField("title", at: \.title)
      InputField("duration", at: \.duration)
      InputField("chapters", at: \.chapters)
      InputField("order", at: \.order)
      InputField("mp3SizeHq", at: \.mp3SizeHq)
      InputField("mp3SizeLq", at: \.mp3SizeLq)
      InputField("externalIdHq", at: \.externalIdHq)
      InputField("externalIdLq", at: \.externalIdLq)
    }
  }

  static var UpdateAudioPartInputType: AppInput<AppSchema.UpdateAudioPartInput> {
    Input(AppSchema.UpdateAudioPartInput.self) {
      InputField("id", at: \.id)
      InputField("audioId", at: \.audioId)
      InputField("title", at: \.title)
      InputField("duration", at: \.duration)
      InputField("chapters", at: \.chapters)
      InputField("order", at: \.order)
      InputField("mp3SizeHq", at: \.mp3SizeHq)
      InputField("mp3SizeLq", at: \.mp3SizeLq)
      InputField("externalIdHq", at: \.externalIdHq)
      InputField("externalIdLq", at: \.externalIdLq)
    }
  }

  static var getAudioPart: AppField<AudioPart, IdentifyEntity> {
    Field("getAudioPart", at: Resolver.getAudioPart) {
      Argument("id", at: \.id)
    }
  }

  static var getAudioParts: AppField<[AudioPart], NoArgs> {
    Field("getAudioParts", at: Resolver.getAudioParts)
  }

  static var createAudioPart: AppField<IdentifyEntity, InputArgs<CreateAudioPartInput>> {
    Field("createAudioPart", at: Resolver.createAudioPart) {
      Argument("input", at: \.input)
    }
  }

  static var createAudioParts: AppField<[IdentifyEntity], InputArgs<[CreateAudioPartInput]>> {
    Field("createAudioParts", at: Resolver.createAudioParts) {
      Argument("input", at: \.input)
    }
  }

  static var updateAudioPart: AppField<AudioPart, InputArgs<UpdateAudioPartInput>> {
    Field("updateAudioPart", at: Resolver.updateAudioPart) {
      Argument("input", at: \.input)
    }
  }

  static var updateAudioParts: AppField<[AudioPart], InputArgs<[UpdateAudioPartInput]>> {
    Field("updateAudioParts", at: Resolver.updateAudioParts) {
      Argument("input", at: \.input)
    }
  }

  static var deleteAudioPart: AppField<AudioPart, IdentifyEntity> {
    Field("deleteAudioPart", at: Resolver.deleteAudioPart) {
      Argument("id", at: \.id)
    }
  }
}

extension AudioPart {
  convenience init(_ input: AppSchema.CreateAudioPartInput) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      audioId: .init(rawValue: input.audioId),
      title: input.title,
      duration: .init(rawValue: input.duration),
      chapters: try NonEmpty<[Int]>.fromArray(input.chapters),
      order: input.order,
      mp3SizeHq: .init(rawValue: input.mp3SizeHq),
      mp3SizeLq: .init(rawValue: input.mp3SizeLq),
      externalIdHq: .init(rawValue: input.externalIdHq),
      externalIdLq: .init(rawValue: input.externalIdLq)
    )
  }

  convenience init(_ input: AppSchema.UpdateAudioPartInput) throws {
    self.init(
      id: .init(rawValue: input.id),
      audioId: .init(rawValue: input.audioId),
      title: input.title,
      duration: .init(rawValue: input.duration),
      chapters: try NonEmpty<[Int]>.fromArray(input.chapters),
      order: input.order,
      mp3SizeHq: .init(rawValue: input.mp3SizeHq),
      mp3SizeLq: .init(rawValue: input.mp3SizeLq),
      externalIdHq: .init(rawValue: input.externalIdHq),
      externalIdLq: .init(rawValue: input.externalIdLq)
    )
  }

  func update(_ input: AppSchema.UpdateAudioPartInput) throws {
    audioId = .init(rawValue: input.audioId)
    title = input.title
    duration = .init(rawValue: input.duration)
    chapters = try NonEmpty<[Int]>.fromArray(input.chapters)
    order = input.order
    mp3SizeHq = .init(rawValue: input.mp3SizeHq)
    mp3SizeLq = .init(rawValue: input.mp3SizeLq)
    externalIdHq = .init(rawValue: input.externalIdHq)
    externalIdLq = .init(rawValue: input.externalIdLq)
    updatedAt = Current.date()
  }
}
