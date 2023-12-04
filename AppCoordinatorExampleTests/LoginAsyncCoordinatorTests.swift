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

    // Need to create 2 separate tasks. Otherwise it will just stop after `await sut.start()`.
    // Beware that the order of Task 1 and 2 can be randommized. A delay is added in Task 2 to help with this.
    // However, Task 1 may take longer than that delay in rare cases.
    // So this test is still a bit flaky. But this good enough for a PoC for now.
    Task { // Task 1
      let username = await sut.start()
      XCTAssertEqual(username, "John")
      exp.fulfill()
    }

    Task { // Task 2
      // Add delay to ensure sut.start() hits the first awaiting code
      try await Task.sleep(for: .milliseconds(100))

      let loginLandingViewController = try XCTUnwrap(nav.viewControllers.last as? LoginLandingViewController)
      sut.loginLandingViewControllerDidSelectLogin(loginLandingViewController)
      let loginViewController = try XCTUnwrap(nav.viewControllers.last as? LoginViewController)
      sut.loginViewController(loginViewController, didLogInWith: "John")
      exp.fulfill()
    }

    await fulfillment(of: [exp])
  }

}
