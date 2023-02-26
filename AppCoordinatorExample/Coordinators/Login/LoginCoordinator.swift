import UIKit

/// An example of a coordinator that manages a UINavigationController and returns a login result.
@MainActor final class LoginCoordinator: Coordinator {

  let window: UIWindow
  private lazy var navigationController = UINavigationController()
  private var continuation: CheckedContinuation<String, Error>?

  init(window: UIWindow) {
    print("\(type(of: self)) \(#function)")
    self.window = window
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  func start() async throws -> String {
    let viewController = LoginLandingViewController()
    viewController.delegate = self
    navigationController.setViewControllers([viewController], animated: false)
    window.rootViewController = navigationController

    return try await withCheckedThrowingContinuation { self.continuation = $0 }
  }

}

extension LoginCoordinator: LoginLandingViewControllerDelegate {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController) {
    let viewController = LoginViewController()
    viewController.delegate = self
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension LoginCoordinator: LoginViewControllerDelegate {
  func loginViewControllerDidFinishLogin(_ viewController: LoginViewController, result: String) {
    continuation?.resume(returning: result)
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    navigationController.popToRootViewController(animated: true)
  }
}
