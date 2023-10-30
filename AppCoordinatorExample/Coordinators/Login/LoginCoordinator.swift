import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String)
}

/// An example of a coordinator that manages a UINavigationController and returns a login result.
final class LoginCoordinator: Coordinator {

  let window: UIWindow
  weak var delegate: LoginCoordinatorDelegate?
  private lazy var navigationController = UINavigationController()

  init(window: UIWindow) {
    print("\(type(of: self)) \(#function)")
    self.window = window
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
    navigationController.navigationBar.scrollEdgeAppearance = appearance

    let viewController = LoginLandingViewController()
    viewController.delegate = self
    navigationController.setViewControllers([viewController], animated: false)
    window.rootViewController = navigationController
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
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String) {
    delegate?.loginCoordinator(self, didLogInWith: username)
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    navigationController.popToRootViewController(animated: true)
  }
}
