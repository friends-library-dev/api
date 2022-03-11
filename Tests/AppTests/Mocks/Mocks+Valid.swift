@testable import App

extension Friend {
  static var valid: Friend {
    let friend = Friend.empty
    friend.name = "George Fox"
    friend.slug = "george-fox"
    friend.born = 1620
    friend.died = 1693
    precondition(friend.isValid)
    return friend
  }
}

extension Document {
  static var valid: Document {
    let document = Document.empty
    document.filename = "No_Cross_No_Crown"
    document.title = "No Cross, No Crown"
    document.slug = "no-cross-no-crown"
    document.published = nil
    precondition(document.isValid)
    return document
  }
}

extension Edition {
  static var valid: Edition {
    let edition = Edition.empty
    edition.type = .original
    edition.editor = nil
    precondition(edition.isValid)
    return edition
  }
}

extension EditionChapter {
  static var valid: EditionChapter {
    let chapter = EditionChapter.empty
    chapter.order = 1
    chapter.shortHeading = "Chapter 1"
    chapter.sequenceNumber = 1
    precondition(chapter.isValid)
    return chapter
  }
}

extension EditionImpression {
  static var valid: EditionImpression {
    let impression = EditionImpression.empty
    impression.paperbackVolumes = .init(100)
    impression.adocLength = 10000
    impression.publishedRevision = "e6d5b8d007f2e459d4f1ae2237c6e92625e1a3ca"
    impression.productionToolchainRevision = "0db3f8aeffa47ba13760ca6de4fe01808cefb581"
    precondition(impression.isValid)
    return impression
  }
}

extension AudioPart {
  static var valid: AudioPart {
    let part = AudioPart.empty
    part.title = "Chapter 7"
    part.order = 7
    part.duration = 3704.5
    part.chapters = .init(4, 5)
    part.mp3SizeHq = 2000001
    part.mp3SizeLq = 1000001
    part.externalIdHq = 200000001
    part.externalIdLq = 200000002
    precondition(part.isValid)
    return part
  }
}

extension Audio {
  static var valid: Audio {
    let audio = Audio.empty
    audio.reader = "Bob Smith"
    audio.m4bSizeLq = 3000000
    audio.m4bSizeHq = 8000000
    audio.mp3ZipSizeLq = 2000000
    audio.mp3ZipSizeHq = 5000000
    audio.externalPlaylistIdHq = nil
    audio.externalPlaylistIdLq = nil
    precondition(audio.isValid)
    return audio
  }
}
