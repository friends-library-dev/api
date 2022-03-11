import XCTest

@testable import App

final class AudioValidityTests: XCTestCase {

  func testEmptyReaderInvalid() {
    let audio = Audio.valid
    audio.reader = ""
    XCTAssertFalse(audio.isValid)
  }

  func testTooSmallExternalPlaylistIdInvalid() {
    var audio = Audio.valid
    audio.externalPlaylistIdLq = 9999999999
    audio.externalPlaylistIdHq = 500
    XCTAssertFalse(audio.isValid)
    audio = Audio.valid
    audio.externalPlaylistIdLq = 500
    audio.externalPlaylistIdHq = 9999999999
    XCTAssertFalse(audio.isValid)
  }

  func testOnlyOneNilPlaylistIdInvalid() {
    var audio = Audio.valid
    audio.externalPlaylistIdHq = nil
    audio.externalPlaylistIdLq = 888888888
    XCTAssertFalse(audio.isValid)
    audio = Audio.valid
    audio.externalPlaylistIdHq = 888888888
    audio.externalPlaylistIdLq = nil
    XCTAssertFalse(audio.isValid)
  }

  func testM4bLqNotSmallerThanHqInvalid() {
    let audio = Audio.valid
    audio.m4bSizeHq = 9000000
    audio.m4bSizeLq = 9000111
    XCTAssertFalse(audio.isValid)
  }

  func testMp3ZipLqNotSmallerThanHqInvalid() {
    let audio = Audio.valid
    audio.mp3ZipSizeHq = 6000000
    audio.mp3ZipSizeLq = 7000000
    XCTAssertFalse(audio.isValid)
  }

  func testZeroFilesizesValid() {
    let audio = Audio.valid
    audio.mp3ZipSizeHq = 0
    audio.mp3ZipSizeLq = 0
    audio.m4bSizeHq = 0
    audio.m4bSizeLq = 0
    XCTAssertTrue(audio.isValid)
  }

  func testTooSmallNonZeroM4bSizeInvalid() {
    var audio = Audio.valid
    audio.m4bSizeHq = 1000
    XCTAssertFalse(audio.isValid)
    audio = Audio.valid
    audio.m4bSizeLq = 1000
    XCTAssertFalse(audio.isValid)
  }

  func testTooSmallNonZeroMp3ZipSizeInvalid() {
    var audio = Audio.valid
    audio.mp3ZipSizeHq = 1000
    XCTAssertFalse(audio.isValid)
    audio = Audio.valid
    audio.mp3ZipSizeLq = 1000
    XCTAssertFalse(audio.isValid)
  }

  func testNonSequentialPartsInvalid() {
    let part1 = AudioPart.valid
    part1.order = 1
    let part2 = AudioPart.valid
    part2.order = 3 // <-- unexpected non-sequential order!!!

    let audio = Audio.valid
    audio.parts = .loaded([part1, part2])
    XCTAssertFalse(audio.isValid)
  }
}
