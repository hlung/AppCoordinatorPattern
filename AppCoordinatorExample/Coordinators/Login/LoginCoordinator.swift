import UIKit

/// An example of a coordinator that manages a UINavigationController and returns a login result.
final class LoginCoordinator: Coordinator {

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

    let viewController = LoginLandingViewController(coordinator: self)
    navigationController.setViewControllers([viewController], animated: false)
    window.rootViewController = navigationController
  }

  // MARK: - Navigation

  func showLoginPage() {
    let viewController = LoginViewController()
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }

  func finish(result: String) {
    self.result = result
    completion?(self)
  }

  func reset() {
    navigationController.popToRootViewController(animated: true)
  }

}
