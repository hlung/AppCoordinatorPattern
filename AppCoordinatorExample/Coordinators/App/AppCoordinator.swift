import UIKit

final class AppCoordinator {

  typealias Dependencies = UsernameProvider

  let rootViewController: UINavigationController
  var childCoordinators: [AnyObject] = []
  var dependencies: Dependencies

  init(navigationController: UINavigationController, dependencies: Dependencies) {
    self.rootViewController = navigationController
    self.dependencies = dependencies
  }

  func start() {
    if dependencies.loggedInUsername != nil {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome() {
    let username = dependencies.loggedInUsername ?? "-"
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
    dependencies.clear()
    childCoordinators.removeAll { $0 === coordinator }
    showLogin()
  }
}

extension AppCoordinator: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    print("Login result: \(username)")
    dependencies.loggedInUsername = username
    childCoordinators.removeAll { $0 === coordinator }
    showHome()
  }
}
