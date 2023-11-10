import UIKit

final class AppNavigator {

  enum Destination {
    case home(username: String)
    case login
  }

  let rootViewController: UINavigationController
  var homeNavigator: HomeNavigator?

  init(navigationController: UINavigationController) {
    self.rootViewController = navigationController
  }

  func start() {
    if UserDefaults.standard.isLoggedIn {
      navigate(to: .home(username: UserDefaults.standard.loggedInUsername!))
    }
    else {
      navigate(to: .login)
    }
  }

  func navigate(to destination: Destination) {
    switch destination {
    case .home:
      showHome()
    case .login:
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome() {
    let navigator = HomeNavigator(navigationController: rootViewController)
    navigator.delegate = self
    navigator.start()
    homeNavigator = navigator
  }

  func showLogin() {
    let viewController = LoginLandingViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)
  }

}

extension AppNavigator: LoginLandingViewControllerDelegate {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController) {
    let viewController = LoginViewController()
    viewController.delegate = self
    rootViewController.pushViewController(viewController, animated: true)
  }
}

extension AppNavigator: LoginViewControllerDelegate {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String) {
    navigate(to: .home(username: username))
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    rootViewController.popToRootViewController(animated: true)
  }
}

extension AppNavigator: HomeNavigatorDelegate {
  func homeNavigatorDidLogOut(_ navigator: HomeNavigator) {
    navigate(to: .login)
  }
}
