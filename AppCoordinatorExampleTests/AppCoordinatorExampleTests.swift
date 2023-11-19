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

  func testLogIn() throws {
    let nav = UINavigationController()
    let sut = AppCoordinator(
      navigationController: nav,
      dependencies: MockDependency.loggedOut
    )

    sut.start()
    let loginCoordinator = try XCTUnwrap(sut.childCoordinators.last as? LoginCoordinator)
    sut.loginCoordinator(loginCoordinator, didLogInWith: "John")
    XCTAssertNotNil(sut.childCoordinators.last as? HomeCoordinator)
  }

  @MainActor
  func testLogInAsync() async throws {
    let nav = UINavigationController()
    let sut = AppCoordinator(
      navigationController: nav,
      dependencies: MockDependency.loggedOut
    )

    sut.start()
//    await sut.start().value
    let loginCoordinator = try XCTUnwrap(sut.childCoordinators.last as? LoginAsyncCoordinator)

    // Even if we have loginCoordinator, its continuation may still be nil...

//    loginCoordinator.continuation?.resume(with: .success("John"))
//    XCTAssertNotNil(sut.childCoordinators.last as? HomeCoordinator)
  }

}

private struct MockDependency: UsernameProvider, StringProvider {
  var loggedInUsername: String?
  var getString: (String) -> Void = { _ in }

  mutating func clear() {
    self.loggedInUsername = nil
  }
}

extension MockDependency {
  static let loggedIn = MockDependency(loggedInUsername: "John")
  static let loggedOut = MockDependency(loggedInUsername: nil)
}
