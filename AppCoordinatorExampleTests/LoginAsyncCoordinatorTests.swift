import XCTest
@testable import AppCoordinatorExample

class LoginAsyncCoordinatorTests: XCTestCase {

  @MainActor
  func testAsyncCoordinator() async throws {
    let nav = UINavigationController()
    let sut = LoginAsyncCoordinator(
      navigationController: nav
    )
    // disable animation so nav.viewControllers is updated right away
    sut.animatedPush = false

    let exp = XCTestExpectation()
    exp.expectedFulfillmentCount = 2

    // Need to create 2 separate tasks. Otherwise it will just stop after first await.
    Task {
      let username = await sut.start()
      XCTAssertEqual(username, "John")
      exp.fulfill()
    }

    Task {
      // Add delay to ensure this task runs after start() is done and awaiting, otherwise test will fail sometimes.
      // To see failure, try comment this out and run this test repeatedly for ~100 times.
      try await Task.sleep(nanoseconds: UInt64(1e7))

      let loginLandingViewController = try XCTUnwrap(nav.viewControllers.last as? LoginLandingViewController)
      sut.loginLandingViewControllerDidSelectLogin(loginLandingViewController)
      let loginViewController = try XCTUnwrap(nav.viewControllers.last as? LoginViewController)
      sut.loginViewController(loginViewController, didLogInWith: "John")
      exp.fulfill()
    }

    await fulfillment(of: [exp])
  }

}
