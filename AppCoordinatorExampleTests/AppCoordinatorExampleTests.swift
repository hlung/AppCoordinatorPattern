//
//  AppCoordinatorExampleTests.swift
//  AppCoordinatorExampleTests
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import XCTest
@testable import AppCoordinatorExample

class AppCoordinatorExampleTests: XCTestCase {

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

    // Fail, loginCoordinator is not created yet
    let loginCoordinator = try XCTUnwrap(sut.childCoordinators.last as? LoginAsyncCoordinator)

    // Even if we have loginCoordinator, its continuation may still be nil...
    // So we still can't trigger login to verify that HomeCoordinator exists.
//    loginCoordinator.continuation?.resume(with: .success("John"))
//    XCTAssertNotNil(sut.childCoordinators.last as? HomeCoordinator)
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
