import XCTest

@testable import App

final class DocumentTests: XCTestCase {

  var validLoaded: Document {
    let friend = Friend.empty
    friend.lang = .en
    let edition = Edition.empty
    edition.isDraft = false
    let document = Document.valid
    document.friend = .loaded(friend)
    document.editions = .loaded([edition])
    return document
  }

  func testEmptyTitleInvalid() {
    let doc = validLoaded
    doc.title = ""
    XCTAssertFalse(doc.isValid)
  }

  func testOriginalTitleTooShortInvalid() {
    let doc = validLoaded
    doc.originalTitle = "Abc"
    XCTAssertFalse(doc.isValid)
  }

  func testOriginalTitleNotCapitalizedInvalid() {
    let doc = validLoaded
    doc.originalTitle = "the life and labors of george dilwynn"
    XCTAssertFalse(doc.isValid)
  }

  func testPublishedDateOutOfBoundsInvalid() {
    var doc = validLoaded
    doc.published = 1500
    XCTAssertFalse(doc.isValid)
    doc = validLoaded
    doc.published = 1901
    XCTAssertFalse(doc.isValid)
  }

  func testTodosOkForDescriptionsIfEditionsNotLoaded() {
    let doc = Document.valid
    doc.description = "TODO"
    doc.partialDescription = "TODO"
    doc.featuredDescription = "TODO"
    XCTAssertTrue(doc.isValid)
  }

  func testTodosInvalidForDescriptionsIfHasNonDraftEdition() {
    let doc = validLoaded
    doc.description = "TODO"
    doc.partialDescription = "TODO"
    doc.featuredDescription = "TODO"
    XCTAssertFalse(doc.isValid)
  }

  func testNonCapitalizedTitleInvalid() {
    let doc = validLoaded
    doc.title = "no Cross, No Crown"
    XCTAssertFalse(doc.isValid)
  }

  func testTooShortTitleInValid() {
    let doc = validLoaded
    doc.title = "No"
    XCTAssertFalse(doc.isValid)
  }

  func testNonSluggySlugInvalid() {
    let doc = validLoaded
    doc.slug = "This is not A Sluggy Slug"
    XCTAssertFalse(doc.isValid)
  }

  func testMalformedFilenameInvalid() {
    let doc = validLoaded
    doc.filename = "This is not A good filename :("
    XCTAssertFalse(doc.isValid)
  }

  func testPrimaryEdition() {
    let updated: Edition = .empty
    updated.type = .updated
    let modernized: Edition = .empty
    modernized.type = .modernized
    let original: Edition = .empty
    original.type = .original

    let document: Document = .empty

    document.editions = .loaded([updated, modernized, original])
    XCTAssertEqual(updated, document.primaryEdition)

    document.editions = .loaded([modernized, original, updated])
    XCTAssertEqual(updated, document.primaryEdition)

    document.editions = .loaded([original, updated, modernized])
    XCTAssertEqual(updated, document.primaryEdition)

    document.editions = .loaded([original, modernized])
    XCTAssertEqual(modernized, document.primaryEdition)

    document.editions = .loaded([modernized, original])
    XCTAssertEqual(modernized, document.primaryEdition)

    document.editions = .loaded([updated, original])
    XCTAssertEqual(updated, document.primaryEdition)

    document.editions = .loaded([original])
    XCTAssertEqual(original, document.primaryEdition)

    document.editions = .loaded([modernized])
    XCTAssertEqual(modernized, document.primaryEdition)
  }
}
