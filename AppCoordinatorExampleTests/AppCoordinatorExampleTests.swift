//
//  AppCoordinatorExampleTests.swift
//  AppCoordinatorExampleTests
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import XCTest
@testable import AppCoordinatorExample

@MainActor
class AppCoordinatorExampleTests: XCTestCase {

  func testAsyncLoggedOutState() async throws {
    let nav = UINavigationController()
    let sut = AppCoordinator(
      navigationController: nav,
      dependencies: .init(
        sessionProvider: MockLoggedOutSessionProvider(),
        appLaunchDataProvider: MockAppLaunchDataProvider()
      )
    )

    sut.start()
    XCTAssertNotNil(nav.viewControllers.last as? FakeSplashViewController)

    // Add delay to ensure sut.start() hits the first awaiting code
    try await Task.sleep(for: .milliseconds(100))

    XCTAssertNotNil(nav.viewControllers.last as? LoginLandingViewController)
  }

  func testAsyncLoggedInState() async throws {
    let nav = UINavigationController()
    let sut = AppCoordinator(
      navigationController: nav,
      dependencies: .init(
        sessionProvider: MockLoggedInSessionProvider(),
        appLaunchDataProvider: MockAppLaunchDataProvider()
      )
    )

    sut.start()
    XCTAssertNotNil(nav.viewControllers.last as? FakeSplashViewController)

    // Add delay to ensure sut.start() hits the first awaiting code
    try await Task.sleep(for: .milliseconds(100))

    XCTAssertNotNil(nav.viewControllers.last as? HomeViewController)
  }

}

class MockLoggedOutSessionProvider: SessionProvider {
  var session: Session?
  func loadSavedSession() {
  }
}

class MockLoggedInSessionProvider: SessionProvider {
  var session: Session?
  func loadSavedSession() {
    self.session = Session(user: User(username: "John"))
  }
}

class MockAppLaunchDataProvider: AppLaunchDataProvider {
  func getAppLaunchData() async throws -> Data {
    return Data()
  }
}
