import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String)
}

/// An example of a coordinator that manages a UINavigationController and returns a login result.
final class LoginCoordinator: Coordinator {

  weak var delegate: LoginCoordinatorDelegate?
  let rootViewController: UINavigationController

  init(navigationController: UINavigationController) {
    print("\(type(of: self)) \(#function)")
    self.rootViewController = navigationController
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  func start() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemGray3
    rootViewController.navigationBar.scrollEdgeAppearance = appearance

    let viewController = LoginLandingViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)
  }

}

extension LoginCoordinator: LoginLandingViewControllerDelegate {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController) {
    let viewController = LoginViewController()
    viewController.delegate = self
    rootViewController.pushViewController(viewController, animated: true)
  }
}

extension LoginCoordinator: LoginViewControllerDelegate {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String) {
    delegate?.loginCoordinator(self, didLogInWith: username)
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    rootViewController.popToRootViewController(animated: true)
  }
}
