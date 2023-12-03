import UIKit

/// An example of a coordinator that manages a UINavigationController and returns a login result.
class LoginAsyncCoordinator: Coordinator {

  let rootViewController: UINavigationController
  private var continuation: CheckedContinuation<String, Never>?
  var animatedPush: Bool = true

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

  @MainActor func start() async -> String {
    let viewController = LoginLandingViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)

    let output = await withCheckedContinuation { self.continuation = $0 }
    rootViewController.setViewControllers([], animated: false)

    return output
  }

}

extension LoginAsyncCoordinator: LoginLandingViewControllerDelegate {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController) {
    let viewController = LoginViewController()
    viewController.delegate = self
    rootViewController.pushViewController(viewController, animated: animatedPush)
  }
}

extension LoginAsyncCoordinator: LoginViewControllerDelegate {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String) {
    continuation?.resume(returning: username)
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    rootViewController.popToRootViewController(animated: animatedPush)
  }
}
