import UIKit

final class AppCoordinator: ParentCoordinator {

  let rootViewController: UINavigationController
  var childCoordinators: [any Coordinator] = []

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
    let coordinator = HomeCoordinator(navigationController: rootViewController)
    addChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showLogin() {
//    let coordinator = LoginCoordinator(navigationController: rootViewController)
//    addChild(coordinator)
//    coordinator.delegate = self
//    coordinator.start()

    Task { @MainActor in
      let coordinator = LoginAsyncCoordinator(navigationController: rootViewController)
      addChild(coordinator)
      let username = try await coordinator.start()
      print("Login result: \(username)")
      UserDefaults.standard.loggedInUsername = username
      removeChild(coordinator)
      showHome()
    }
  }
}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    UserDefaults.standard.clear()
    removeChild(coordinator)
    showLogin()
  }
}

//extension AppCoordinator: LoginCoordinatorDelegate {
//  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
//    print("Login result: \(username)")
//    UserDefaults.standard.loggedInUsername = username
//    removeChild(coordinator)
//    showHome()
//  }
//}
