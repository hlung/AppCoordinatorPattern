import UIKit

/// An example of a coordinator that manages a UINavigationController and returns a login result.
final class LoginCoordinator: ChildCoordinator {

  var completion: ((LoginCoordinator) -> Void)?
  var result: String = ""

  let window: UIWindow
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
  func loginViewControllerDidFinishLogin(_ viewController: LoginViewController, result: String) {
    self.result = result
    completion?(self)
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    navigationController.popToRootViewController(animated: true)
  }
}
