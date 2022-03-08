// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var FriendType: ModelType<Friend> {
    Type(Friend.self) {
      Field("id", at: \.id.rawValue.lowercased)
      Field("lang", at: \.lang)
      Field("name", at: \.name)
      Field("slug", at: \.slug)
      Field("gender", at: \.gender)
      Field("description", at: \.description)
      Field("born", at: \.born)
      Field("died", at: \.died)
      Field("published", at: \.published)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("isCompilations", at: \.isCompilations)
      Field("directoryPath", at: \.directoryPath)
      Field("hasNonDraftDocument", at: \.hasNonDraftDocument)
      Field("relatedDocuments", at: \.relatedDocuments)
      Field("alphabeticalName", at: \.alphabeticalName)
      Field("primaryResidence", at: \.primaryResidence)
      Field("documents", with: \.documents)
      Field("residences", with: \.residences)
      Field("quotes", with: \.quotes)
    }
  }

  struct CreateFriendInput: Codable {
    let id: UUID?
    let lang: Lang
    let name: String
    let slug: String
    let gender: Friend.Gender
    let description: String
    let born: Int?
    let died: Int?
    let published: String?
  }

  struct UpdateFriendInput: Codable {
    let id: UUID
    let lang: Lang
    let name: String
    let slug: String
    let gender: Friend.Gender
    let description: String
    let born: Int?
    let died: Int?
    let published: String?
  }

  static var CreateFriendInputType: AppInput<AppSchema.CreateFriendInput> {
    Input(AppSchema.CreateFriendInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("name", at: \.name)
      InputField("slug", at: \.slug)
      InputField("gender", at: \.gender)
      InputField("description", at: \.description)
      InputField("born", at: \.born)
      InputField("died", at: \.died)
      InputField("published", at: \.published)
    }
  }

  static var UpdateFriendInputType: AppInput<AppSchema.UpdateFriendInput> {
    Input(AppSchema.UpdateFriendInput.self) {
      InputField("id", at: \.id)
      InputField("lang", at: \.lang)
      InputField("name", at: \.name)
      InputField("slug", at: \.slug)
      InputField("gender", at: \.gender)
      InputField("description", at: \.description)
      InputField("born", at: \.born)
      InputField("died", at: \.died)
      InputField("published", at: \.published)
    }
  }

  static var getFriend: AppField<Friend, IdentifyEntity> {
    Field("getFriend", at: Resolver.getFriend) {
      Argument("id", at: \.id)
    }
  }

  static var getFriends: AppField<[Friend], NoArgs> {
    Field("getFriends", at: Resolver.getFriends)
  }

  static var createFriend: AppField<IdentifyEntity, InputArgs<CreateFriendInput>> {
    Field("createFriend", at: Resolver.createFriend) {
      Argument("input", at: \.input)
    }
  }

  static var createFriends: AppField<[IdentifyEntity], InputArgs<[CreateFriendInput]>> {
    Field("createFriends", at: Resolver.createFriends) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriend: AppField<Friend, InputArgs<UpdateFriendInput>> {
    Field("updateFriend", at: Resolver.updateFriend) {
      Argument("input", at: \.input)
    }
  }

  static var updateFriends: AppField<[Friend], InputArgs<[UpdateFriendInput]>> {
    Field("updateFriends", at: Resolver.updateFriends) {
      Argument("input", at: \.input)
    }
  }

  static var deleteFriend: AppField<Friend, IdentifyEntity> {
    Field("deleteFriend", at: Resolver.deleteFriend) {
      Argument("id", at: \.id)
    }
  }
}

extension Friend {
  convenience init(_ input: AppSchema.CreateFriendInput) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      lang: input.lang,
      name: input.name,
      slug: input.slug,
      gender: input.gender,
      description: input.description,
      born: input.born,
      died: input.died,
      published: input.published != nil ? try Date.fromISO(input.published!) : nil
    )
  }

  convenience init(_ input: AppSchema.UpdateFriendInput) throws {
    self.init(
      id: .init(rawValue: input.id),
      lang: input.lang,
      name: input.name,
      slug: input.slug,
      gender: input.gender,
      description: input.description,
      born: input.born,
      died: input.died,
      published: input.published != nil ? try Date.fromISO(input.published!) : nil
    )
  }

  func update(_ input: AppSchema.UpdateFriendInput) throws {
    lang = input.lang
    name = input.name
    slug = input.slug
    gender = input.gender
    description = input.description
    born = input.born
    died = input.died
    published = input.published != nil ? try Date.fromISO(input.published!) : nil
    updatedAt = Current.date()
  }
}
