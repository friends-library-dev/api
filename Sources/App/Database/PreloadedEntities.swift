import DuetSQL
import Foundation

actor PreloadedEntities: SQLQuerying {
  private var client: MemoryClient<PreloadedEntitiesStore>

  init(store: PreloadedEntitiesStore) {
    client = MemoryClient(store: store)
  }

  func select<M: Model>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint<M>]?,
    orderBy order: SQL.Order<M>?,
    limit: Int?
  ) async throws -> [M] {
    try await client.select(Model, where: constraints, orderBy: order, limit: limit)
  }

  func flush() {
    client.store.flush()
  }
}

final class PreloadedEntitiesStore: MemoryStore {
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

  public func keyPath<M: Model>(to: M.Type) -> Models<M> {
    switch M.tableName {
      case Friend.tableName:
        return \PreloadedEntitiesStore.friends as! Models<M>
      case FriendQuote.tableName:
        return \PreloadedEntitiesStore.friendQuotes as! Models<M>
      case FriendResidence.tableName:
        return \PreloadedEntitiesStore.friendResidences as! Models<M>
      case FriendResidenceDuration.tableName:
        return \PreloadedEntitiesStore.friendResidenceDurations as! Models<M>
      case Document.tableName:
        return \PreloadedEntitiesStore.documents as! Models<M>
      case DocumentTag.tableName:
        return \PreloadedEntitiesStore.documentTags as! Models<M>
      case RelatedDocument.tableName:
        return \PreloadedEntitiesStore.relatedDocuments as! Models<M>
      case Edition.tableName:
        return \PreloadedEntitiesStore.editions as! Models<M>
      case EditionImpression.tableName:
        return \PreloadedEntitiesStore.editionImpressions as! Models<M>
      case EditionChapter.tableName:
        return \PreloadedEntitiesStore.editionChapters as! Models<M>
      case Audio.tableName:
        return \PreloadedEntitiesStore.audios as! Models<M>
      case AudioPart.tableName:
        return \PreloadedEntitiesStore.audioParts as! Models<M>
      case Isbn.tableName:
        return \PreloadedEntitiesStore.isbns as! Models<M>
      default:
        preconditionFailure()
    }
  }
}

// helpers

private func toDict<M: Model>(_ models: [M]) -> [M.IdValue: M] {
  var dict = Dictionary<M.IdValue, M>.init(minimumCapacity: models.count)
  models.forEach { model in dict[model.id] = model }
  return dict
}

// extensions

extension PreloadedEntities {
  func setLegacyAppEditions(data: Data, lang: Lang) {
    switch lang {
      case .en:
        client.store.legacyRestAppEditionsDataEnglish = data
      case .es:
        client.store.legacyRestAppEditionsDataSpanish = data
    }
  }

  func getLegacyAppEditions(lang: Lang) -> Data? {
    switch lang {
      case .en:
        return client.store.legacyRestAppEditionsDataEnglish
      case .es:
        return client.store.legacyRestAppEditionsDataSpanish
    }
  }

  func setLegacyAppAudios(data: Data, lang: Lang) {
    switch lang {
      case .en:
        client.store.legacyRestAppAudiosDataEnglish = data
      case .es:
        client.store.legacyRestAppAudiosDataSpanish = data
    }
  }

  func getLegacyAppAudios(lang: Lang) -> Data? {
    switch lang {
      case .en:
        return client.store.legacyRestAppAudiosDataEnglish
      case .es:
        return client.store.legacyRestAppAudiosDataSpanish
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
