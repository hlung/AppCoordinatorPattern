//
//  AppCoordinatorExampleTests.swift
//  AppCoordinatorExampleTests
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import XCTest
@testable import AppCoordinatorExample

class AppCoordinatorExampleTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testLogIn() {
    let nav = UINavigationController()
    let sut = AppCoordinatorRedux(
      navigationController: nav,
      dependencies: MockDependency.loggedOut
    )
    sut.start()
    XCTAssertEqual(sut.state.loggedInUsername, nil)
    XCTAssertTrue(sut.rootViewController.viewControllers.first?.isKind(of: LoginLandingViewController.self) == true)

    sut.send(.login("John"))
    XCTAssertEqual(sut.state.loggedInUsername, "John")
    XCTAssertTrue(sut.rootViewController.viewControllers.first?.isKind(of: HomeViewController.self) == true)
  }

}

private struct MockDependency: UsernameProvider {
  var loggedInUsername: String?
  
  mutating func clear() {
    self.loggedInUsername = nil
  }
}

extension MockDependency {
  static let loggedIn = MockDependency(loggedInUsername: "John")
  static let loggedOut = MockDependency(loggedInUsername: nil)
}
