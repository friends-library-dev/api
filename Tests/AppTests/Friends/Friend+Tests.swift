import XCTest

@testable import App

final class FriendTests: XCTestCase {

  func testAlphabeticalName() {
    let friend = Friend.empty
    friend.name = "Jared Henderson"
    XCTAssertEqual(friend.alphabeticalName, "Henderson, Jared")
  }

  func testAlphabeticalMaidenName() {
    let friend = Friend.empty
    friend.name = "Catherine (Payton) Phillips"
    XCTAssertEqual(friend.alphabeticalName, "Phillips, Catherine (Payton)")
  }

  func testAlphabeticalNameWithInitials() {
    let friend = Friend.empty
    friend.name = "Sarah R. Grubb"
    XCTAssertEqual(friend.alphabeticalName, "Grubb, Sarah R.")
  }
}
