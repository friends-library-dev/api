import XCTest

@testable import App

final class AudioPartValidityTests: XCTestCase {

  func testEmptyTitleInvalid() {
    let part = AudioPart.valid
    part.title = ""
    XCTAssertFalse(part.isValid)
  }

  func testTooSmallDurationInvalid() {
    let part = AudioPart.valid
    part.duration = 120
    XCTAssertFalse(part.isValid)
  }

  func testTooSmallDurationValidIfNotPublished() {
    let part = AudioPart.valid
    part.mp3SizeLq = 0
    part.mp3SizeHq = 0
    part.duration = 120
    XCTAssertTrue(part.isValid)
  }

  func testNegativeValuesForMp3SizeInvalid() {
    var part = AudioPart.valid
    part.mp3SizeHq = -1
    XCTAssertFalse(part.isValid)
    part = AudioPart.valid
    part.mp3SizeLq = -1
    XCTAssertFalse(part.isValid)
  }

  func testSameSizeForMp3HqLqInvalid() {
    let part = AudioPart.valid
    part.mp3SizeHq = 888888
    part.mp3SizeLq = 888888
    XCTAssertFalse(part.isValid)
  }

  func testLqMp3LargerThanHqInvalid() {
    let part = AudioPart.valid
    part.mp3SizeHq = 888888
    part.mp3SizeLq = 999999
    XCTAssertFalse(part.isValid)
  }

  func testOrderLessThan1Iinvalid() {
    let part = AudioPart.valid
    part.order = 0
    XCTAssertFalse(part.isValid)
  }

  func testNegativeChapterValueInvalid() {
    let part = AudioPart.valid
    part.chapters = .init(-5)
    XCTAssertFalse(part.isValid)
  }

  func testNonSequencedChaptersInvalid() {
    let part = AudioPart.valid
    part.chapters = .init(3, 5)
    XCTAssertFalse(part.isValid)
  }

  func testSameNonZeroExternalIdsInvalid() {
    let part = AudioPart.valid
    part.externalIdHq = 7777777
    part.externalIdLq = 7777777
    XCTAssertFalse(part.isValid)
  }

  func testFunnyLookingExternalIdsInvalid() {
    var part = AudioPart.valid
    part.externalIdHq = 500
    XCTAssertFalse(part.isValid)
    part = AudioPart.valid
    part.externalIdLq = 600
    XCTAssertFalse(part.isValid)
  }

  func testZeroDraftStateItemsValid() {
    let part = AudioPart.valid
    part.mp3SizeHq = 0
    part.mp3SizeLq = 0
    part.externalIdHq = 0
    part.externalIdLq = 0
    XCTAssertTrue(part.isValid)
  }
}
