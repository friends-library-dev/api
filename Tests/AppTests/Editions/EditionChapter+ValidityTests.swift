import XCTest

@testable import App

final class EditionChapterValidityTests: XCTestCase {
  func testOrderLessThan1OrSuperBigInvalid() {
    let chapter = EditionChapter.valid
    chapter.order = 0
    XCTAssertFalse(chapter.isValid)
    chapter.order = 400
    XCTAssertFalse(chapter.isValid)
  }

  func testWierdValueForSequenceNumberInvalid() {
    let chapter = EditionChapter.valid
    chapter.sequenceNumber = 0
    XCTAssertFalse(chapter.isValid)
    chapter.sequenceNumber = 201
    XCTAssertFalse(chapter.isValid)
  }

  func testEmptyOrNonCapitalizedShortHeadingInvalid() {
    let chapter = EditionChapter.valid
    chapter.shortHeading = ""
    XCTAssertFalse(chapter.isValid)
    chapter.shortHeading = "bad lowercased"
    XCTAssertFalse(chapter.isValid)
  }

  func testEmptyOrNonCapitalizedNonSequenceTitleInvalid() {
    let chapter = EditionChapter.valid
    chapter.nonSequenceTitle = ""
    XCTAssertFalse(chapter.isValid)
    chapter.nonSequenceTitle = "bad lowercased"
    XCTAssertFalse(chapter.isValid)
  }

  func testSequenceNumberAndNonSequenceTitleBothNullInvalid() {
    let chapter = EditionChapter.valid
    chapter.sequenceNumber = nil
    chapter.nonSequenceTitle = nil
    XCTAssertFalse(chapter.isValid)
  }
}
