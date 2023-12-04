import XCTest
@testable import AppCoordinatorExample

@MainActor
class AppCoordinatorExampleTests: XCTestCase {

  func testAsyncLoggedOutState() async throws {
    let nav = MockNoAnimationNavigationController()
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

    let loginLandingVC = try XCTUnwrap(nav.viewControllers.last as? LoginLandingViewController)
    loginLandingVC.logInButtonDidTap()

    let loginVC = try XCTUnwrap(nav.viewControllers.last as? LoginViewController)
    loginVC.delegate?.loginViewController(loginVC, didLogInWith: "John")

    try await Task.sleep(for: .milliseconds(100))

    let homeVC = try XCTUnwrap(nav.viewControllers.last as? HomeViewController)
    XCTAssertEqual(homeVC.username, "John")
  }

  func testAsyncLoggedInState() async throws {
    let nav = MockNoAnimationNavigationController()
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
