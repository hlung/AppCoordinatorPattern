import XCTest
@testable import AppCoordinatorExample

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

class MockNoAnimationNavigationController: UINavigationController {
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: false)
  }

  override func popViewController(animated: Bool) -> UIViewController? {
    super.popViewController(animated: false)
  }

  override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
    super.setViewControllers(viewControllers, animated: false)
  }
}
