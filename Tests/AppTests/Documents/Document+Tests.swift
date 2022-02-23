import XCTVapor
import XCTVaporUtils

@testable import App

final class DocumentTests: AppTestCase {
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
