import XCTest

@testable import App

final class PostgresTests: XCTestCase {

  func testStringApostrophesEscaped() {
    let string = Postgres.Data.string("don't")
    XCTAssertEqual(string.param, "'don''t'")
  }
}
