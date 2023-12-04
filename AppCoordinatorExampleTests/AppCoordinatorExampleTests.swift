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
        sessionProvider: MockSessionProvider(),
        appLaunchDataProvider: MockAppLaunchDataProvider()
      )
    )

    sut.start()
    XCTAssertNotNil(nav.viewControllers.last as? FakeSplashViewController)

    // Add delay to ensure sut.start() hits the first awaiting code
    try await Task.sleep(for: .milliseconds(10))

    XCTAssertNotNil(nav.viewControllers.last as? LoginLandingViewController)
  }

  func testAsyncLoggedInState() async throws {
    let nav = UINavigationController()
    let sut = AppCoordinator(
      navigationController: nav,
      dependencies: .init(
        sessionProvider: {
          let provider = MockSessionProvider()
          provider.session = Session(user: User(username: "John"))
          return provider
        }(),
        appLaunchDataProvider: MockAppLaunchDataProvider()
      )
    )

    sut.start()
    XCTAssertNotNil(nav.viewControllers.last as? FakeSplashViewController)

    // Add delay to ensure sut.start() hits the first awaiting code
    try await Task.sleep(for: .milliseconds(10))

    XCTAssertNotNil(nav.viewControllers.last as? HomeViewController)
  }

}

class MockSessionProvider: SessionProvider {
  var session: Session? = nil
  func loadSavedSession() {
  }
}

class MockAppLaunchDataProvider: AppLaunchDataProvider {
  func getAppLaunchData() async throws -> Data {
    return Data()
  }
}
