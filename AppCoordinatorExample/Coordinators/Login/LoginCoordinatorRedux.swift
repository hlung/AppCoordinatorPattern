import UIKit

/// An example of a coordinator that manages a UINavigationController and returns a login result.
final class LoginCoordinatorRedux {

  weak var actionSender: (any ActionSender<AppCoordinatorReduxNested.Action>)?
  let rootViewController: UINavigationController

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

  func start() {
    let viewController = LoginLandingViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)
  }

  func stop() {
    rootViewController.setViewControllers([], animated: false)
  }

}

extension LoginCoordinatorRedux: LoginLandingViewControllerDelegate {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController) {
    let viewController = LoginViewController()
    viewController.delegate = self
    rootViewController.pushViewController(viewController, animated: true)
  }
}

extension LoginCoordinatorRedux: LoginViewControllerDelegate {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String) {
    actionSender?.send(.login(username))
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    rootViewController.popToRootViewController(animated: true)
  }
}
