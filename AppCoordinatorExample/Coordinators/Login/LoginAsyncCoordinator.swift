import UIKit

/// An example of a coordinator that manages a UINavigationController and returns a login result.
final class LoginAsyncCoordinator: AsyncCoordinator {

  let rootViewController: UINavigationController
  private var continuation: CheckedContinuation<String, Error>?

  init(navigationController: UINavigationController) {
    print("[\(type(of: self))] \(#function)")
    self.rootViewController = navigationController
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("[\(type(of: self))] \(#function)")
  }

  @MainActor func start() async throws -> String {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemGray3
    rootViewController.navigationBar.scrollEdgeAppearance = appearance

    let viewController = LoginLandingViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)

    let output = try await withCheckedThrowingContinuation { self.continuation = $0 }

    rootViewController.setViewControllers([], animated: false)

    return output
  }

}

extension LoginAsyncCoordinator: LoginLandingViewControllerDelegate {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController) {
    let viewController = LoginViewController()
    viewController.delegate = self
    rootViewController.pushViewController(viewController, animated: true)
  }
}

extension LoginAsyncCoordinator: LoginViewControllerDelegate {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String) {
    continuation?.resume(returning: username)
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    rootViewController.popToRootViewController(animated: true)
  }
}
