import UIKit

final class AppCoordinator {

  let rootViewController: UINavigationController
  var childCoordinators: [AnyObject] = []

  init(navigationController: UINavigationController) {
    self.rootViewController = navigationController
  }

  func start() {
    if UserDefaults.standard.isLoggedIn {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome() {
    let username = UserDefaults.standard.loggedInUsername ?? "-"
    let coordinator = HomeCoordinator(navigationController: rootViewController, username: username)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showLogin() {
    let coordinator = LoginCoordinator(navigationController: rootViewController)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }
}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    UserDefaults.standard.clear()
    childCoordinators.removeAll { $0 === coordinator }
    showLogin()
  }
}

extension AppCoordinator: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    print("Login result: \(username)")
    UserDefaults.standard.loggedInUsername = username
    childCoordinators.removeAll { $0 === coordinator }
    showHome()
  }
}
