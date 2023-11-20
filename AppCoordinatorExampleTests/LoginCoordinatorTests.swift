import XCTest
@testable import AppCoordinatorExample

class LoginCoordinatorTests: XCTestCase {

  func testCoordinator() throws {
    let nav = UINavigationController()
    let sut = LoginCoordinator(
      navigationController: nav
    )
    // disable animation so nav.viewControllers is updated right away
    sut.animatedPush = false

    sut.start()
    let loginLandingViewController = try XCTUnwrap(nav.viewControllers.last as? LoginLandingViewController)

    sut.loginLandingViewControllerDidSelectLogin(loginLandingViewController)
    let loginViewController = try XCTUnwrap(nav.viewControllers.last as? LoginViewController)

    sut.loginViewController(loginViewController, didLogInWith: "John")
    // Use Cuckoo to verify that these are called:
    // - sut.lifecycleDelegate.coordinatorDidFinish()
    // - sut.resultDelegate.loginCoordinator(_:didLogInWith:)
  }

  @MainActor
  func testAsyncCoordinator() async throws {
    let nav = UINavigationController()
    let sut = LoginAsyncCoordinator(
      navigationController: nav
    )
    // disable animation so nav.viewControllers is updated right away
    sut.animatedPush = false

    // Need to create 2 separate tasks. Otherwise it will just stop after first await.
    Task {
      let username = await sut.start()
      XCTAssertEqual(username, "John")
    }

    Task {
      try await Task.sleep(nanoseconds: UInt64(100))
      let loginLandingViewController = try XCTUnwrap(nav.viewControllers.last as? LoginLandingViewController)
      sut.loginLandingViewControllerDidSelectLogin(loginLandingViewController)
      let loginViewController = try XCTUnwrap(nav.viewControllers.last as? LoginViewController)

      sut.loginViewController(loginViewController, didLogInWith: "John")
    }
  }

}
