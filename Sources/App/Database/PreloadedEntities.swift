import Foundation

actor PreloadedEntities: SQLQuerying, InMemoryDatabase {
  var friends: [Friend.Id: Friend]
  var friendQuotes: [FriendQuote.Id: FriendQuote]
  var friendResidences: [FriendResidence.Id: FriendResidence]
  var friendResidenceDurations: [FriendResidenceDuration.Id: FriendResidenceDuration]
  var documents: [Document.Id: Document]
  var documentTags: [DocumentTag.Id: DocumentTag]
  var relatedDocuments: [RelatedDocument.Id: RelatedDocument]
  var editions: [Edition.Id: Edition]
  var editionImpressions: [EditionImpression.Id: EditionImpression]
  var editionChapters: [EditionChapter.Id: EditionChapter]
  var audios: [Audio.Id: Audio]
  var audioParts: [AudioPart.Id: AudioPart]
  var isbns: [Isbn.Id: Isbn]
  var legacyRestAppEditionsDataEnglish: Data?
  var legacyRestAppEditionsDataSpanish: Data?
  var legacyRestAppAudiosDataEnglish: Data?
  var legacyRestAppAudiosDataSpanish: Data?
  // ⚠️ when adding new properties, make sure you flush them in self.flush()

  init(
    friends: [Friend.Id: Friend] = [:],
    friendQuotes: [FriendQuote.Id: FriendQuote] = [:],
    friendResidences: [FriendResidence.Id: FriendResidence] = [:],
    friendResidenceDurations: [FriendResidenceDuration.Id: FriendResidenceDuration] = [:],
    documents: [Document.Id: Document] = [:],
    documentTags: [DocumentTag.Id: DocumentTag] = [:],
    relatedDocuments: [RelatedDocument.Id: RelatedDocument] = [:],
    editions: [Edition.Id: Edition] = [:],
    editionImpressions: [EditionImpression.Id: EditionImpression] = [:],
    editionChapters: [EditionChapter.Id: EditionChapter] = [:],
    audios: [Audio.Id: Audio] = [:],
    audioParts: [AudioPart.Id: AudioPart] = [:],
    isbns: [Isbn.Id: Isbn] = [:]
  ) {
    self.friends = friends
    self.friendQuotes = friendQuotes
    self.friendResidences = friendResidences
    self.friendResidenceDurations = friendResidenceDurations
    self.documents = documents
    self.documentTags = documentTags
    self.relatedDocuments = relatedDocuments
    self.editions = editions
    self.editionImpressions = editionImpressions
    self.editionChapters = editionChapters
    self.audios = audios
    self.audioParts = audioParts
    self.isbns = isbns

    for friend in friends.values {
      friend.documents = .loaded([])
      friend.residences = .loaded([])
      friend.quotes = .loaded([])
    }

    for (_, document) in documents {
      document.editions = .loaded([])
      document.tags = .loaded([])
      document.relatedDocuments = .loaded([])
      if let friend = friends[document.friendId] {
        friend.documents.push(document)
        document.friend = .loaded(friend)
      }

      if let altLanguageId = document.altLanguageId,
         let altLanguageDocument = documents[altLanguageId] {
        document.altLanguageDocument = .loaded(altLanguageDocument)
      } else {
        document.altLanguageDocument = .loaded(nil)
      }
    }

    for (_, residence) in friendResidences {
      residence.durations = .loaded([])
      if let friend = friends[residence.friendId] {
        friend.residences.push(residence)
        residence.friend = .loaded(friend)
      }
    }

    for (_, duration) in friendResidenceDurations {
      if let residence = friendResidences[duration.friendResidenceId] {
        residence.durations.push(duration)
        duration.residence = .loaded(residence)
      }
    }

    for (_, quote) in friendQuotes {
      if let friend = friends[quote.friendId] {
        friend.quotes.push(quote)
        quote.friend = .loaded(friend)
      }
    }

    for (_, tag) in documentTags {
      if let document = documents[tag.documentId] {
        document.tags.push(tag)
        tag.document = .loaded(document)
      }
    }

    for (_, relatedDocument) in relatedDocuments {
      if let parentDocument = documents[relatedDocument.parentDocumentId] {
        parentDocument.relatedDocuments.push(relatedDocument)
        relatedDocument.parentDocument = .loaded(parentDocument)
      }
      if let document = documents[relatedDocument.documentId] {
        relatedDocument.document = .loaded(document)
      }
    }

    for (_, edition) in editions {
      // do this BEFORE setting optional children (Impression, Audio)
      edition.chapters = .loaded([])
      edition.impression = .loaded(nil)
      edition.audio = .loaded(nil)
      edition.isbn = .loaded(nil)

      if let document = documents[edition.documentId] {
        document.editions.push(edition)
        edition.document = .loaded(document)
      }
    }

    for (_, isbn) in isbns {
      if let editionId = isbn.editionId, let edition = editions[editionId] {
        edition.isbn = .loaded(isbn)
        isbn.edition = .loaded(edition)
      }
    }

    for (_, impression) in editionImpressions {
      if let edition = editions[impression.editionId] {
        edition.impression = .loaded(impression)
        impression.edition = .loaded(edition)
      }
    }

    for (_, audio) in audios {
      audio.parts = .loaded([])
      if let edition = editions[audio.editionId] {
        edition.audio = .loaded(audio)
        audio.edition = .loaded(edition)
      }
    }

    for (_, chapter) in editionChapters {
      if let edition = editions[chapter.editionId] {
        edition.chapters.push(chapter)
        chapter.edition = .loaded(edition)
      }
    }

    for (_, audioPart) in audioParts {
      if let audio = audios[audioPart.audioId] {
        audio.parts.push(audioPart)
        audioPart.audio = .loaded(audio)
      }
    }
  }

  func flush() {
    friends = [:]
    friendQuotes = [:]
    friendResidences = [:]
    friendResidenceDurations = [:]
    documents = [:]
    documentTags = [:]
    relatedDocuments = [:]
    editions = [:]
    editionImpressions = [:]
    editionChapters = [:]
    audios = [:]
    audioParts = [:]
    isbns = [:]
    legacyRestAppEditionsDataEnglish = nil
    legacyRestAppEditionsDataSpanish = nil
    legacyRestAppAudiosDataEnglish = nil
    legacyRestAppAudiosDataSpanish = nil
  }

  convenience init(
    friends: [Friend] = [],
    friendQuotes: [FriendQuote] = [],
    friendResidences: [FriendResidence] = [],
    friendResidenceDurations: [FriendResidenceDuration] = [],
    documents: [Document] = [],
    documentTags: [DocumentTag] = [],
    relatedDocuments: [RelatedDocument] = [],
    editions: [Edition] = [],
    editionImpressions: [EditionImpression] = [],
    editionChapters: [EditionChapter] = [],
    audios: [Audio] = [],
    audioParts: [AudioPart] = [],
    isbns: [Isbn] = []
  ) {
    self.init(
      friends: toDict(friends),
      friendQuotes: toDict(friendQuotes),
      friendResidences: toDict(friendResidences),
      friendResidenceDurations: toDict(friendResidenceDurations),
      documents: toDict(documents),
      documentTags: toDict(documentTags),
      relatedDocuments: toDict(relatedDocuments),
      editions: toDict(editions),
      editionImpressions: toDict(editionImpressions),
      editionChapters: toDict(editionChapters),
      audios: toDict(audios),
      audioParts: toDict(audioParts),
      isbns: toDict(isbns)
    )
  }

  func models<M: DuetModel>(of Model: M.Type) async throws -> [M.IdValue: M] {
    switch Model.tableName {
      case Friend.tableName:
        return friends as! [M.IdValue: M]
      case FriendQuote.tableName:
        return friendQuotes as! [M.IdValue: M]
      case FriendResidence.tableName:
        return friendResidences as! [M.IdValue: M]
      case FriendResidenceDuration.tableName:
        return friendResidenceDurations as! [M.IdValue: M]
      case Document.tableName:
        return documents as! [M.IdValue: M]
      case DocumentTag.tableName:
        return documentTags as! [M.IdValue: M]
      case RelatedDocument.tableName:
        return relatedDocuments as! [M.IdValue: M]
      case Edition.tableName:
        return editions as! [M.IdValue: M]
      case EditionImpression.tableName:
        return editionImpressions as! [M.IdValue: M]
      case EditionChapter.tableName:
        return editionChapters as! [M.IdValue: M]
      case Audio.tableName:
        return audios as! [M.IdValue: M]
      case AudioPart.tableName:
        return audioParts as! [M.IdValue: M]
      case Isbn.tableName:
        return isbns as! [M.IdValue: M]
      default:
        throw PreloadedEntitiesError.unsupportedModelType(Model.tableName)
    }
  }
}

// helpers

private func toDict<M: DuetModel>(_ models: [M]) -> [M.IdValue: M] {
  var dict = Dictionary<M.IdValue, M>.init(minimumCapacity: models.count)
  models.forEach { model in dict[model.id] = model }
  return dict
}

// extensions

extension PreloadedEntities {
  func setLegacyAppEditions(data: Data, lang: Lang) {
    switch lang {
      case .en:
        legacyRestAppEditionsDataEnglish = data
      case .es:
        legacyRestAppEditionsDataSpanish = data
    }
  }

  func getLegacyAppEditions(lang: Lang) -> Data? {
    switch lang {
      case .en:
        return legacyRestAppEditionsDataEnglish
      case .es:
        return legacyRestAppEditionsDataSpanish
    }
  }

  func setLegacyAppAudios(data: Data, lang: Lang) {
    switch lang {
      case .en:
        legacyRestAppAudiosDataEnglish = data
      case .es:
        legacyRestAppAudiosDataSpanish = data
    }
  }

  func getLegacyAppAudios(lang: Lang) -> Data? {
    switch lang {
      case .en:
        return legacyRestAppAudiosDataEnglish
      case .es:
        return legacyRestAppAudiosDataSpanish
    }
  }
}

enum PreloadedEntitiesError: Error, LocalizedError {
  case unsupportedModelType(String)

  var errorDescription: String? {
    switch self {
      case .unsupportedModelType(let tableName):
        return "Model with table name `\(tableName)` not available in PreloadedEntities"
    }
  }
}

extension Children {
  mutating func push(_ child: C) {
    switch self {
      case .notLoaded:
        self = .loaded([child])
      case .loaded(let children):
        self = .loaded(children + [child])
    }
  }
}
