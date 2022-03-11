import XCTest

@testable import App

final class EditionImpressionValidityTests: XCTestCase {
  func testOutOfBoundPaperbackVolumesInvalid() {
    let impression = EditionImpression.valid
    impression.paperbackVolumes = .init(0)
    XCTAssertFalse(impression.isValid)
    impression.paperbackVolumes = .init(100, 999999)
    XCTAssertFalse(impression.isValid)
  }

  func testOutOfBoundsAdocLengthInvalid() {
    let impression = EditionImpression.valid
    impression.adocLength = 100
    XCTAssertFalse(impression.isValid)
    impression.adocLength = 33333333333
    XCTAssertFalse(impression.isValid)
  }

  func testNonGitCommitFullShaPublishedRevisionInvalid() {
    let impression = EditionImpression.valid
    impression.publishedRevision = "not a sha"
    XCTAssertFalse(impression.isValid)
  }

  func testNonGitCommitFullShaProductionToolchainRevisionInvalid() {
    let impression = EditionImpression.valid
    impression.productionToolchainRevision = "not a sha"
    XCTAssertFalse(impression.isValid)
  }
}
