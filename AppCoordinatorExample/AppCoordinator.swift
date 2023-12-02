import UIKit

final class AppCoordinator {

  class Dependencies {
    let sessionProvider: SessionProvider
    let appLaunchDataProvider: AppLaunchDataProvider

    init(sessionProvider: SessionProvider, appLaunchDataProvider: AppLaunchDataProvider) {
      self.sessionProvider = sessionProvider
      self.appLaunchDataProvider = appLaunchDataProvider
    }
  }

  let rootViewController: UINavigationController
  let dependencies: Dependencies
  private var childCoordinators: [AnyObject] = []

  init(navigationController: UINavigationController, dependencies: Dependencies) {
    self.rootViewController = navigationController
    self.dependencies = dependencies
  }

  func start() {
    if let username = dependencies.sessionProvider.session?.user.username {
      showHome(username)
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome(_ username: String) {
    let coordinator = HomeCoordinator(navigationController: rootViewController, username: username)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showLogin() {
    let coordinator = LoginCoordinator(navigationController: rootViewController)
    childCoordinators.append(coordinator)
    coordinator.resultDelegate = self
    coordinator.lifecycleDelegate = self
    coordinator.start()
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    dependencies.sessionProvider.session = nil
    childCoordinators.removeAll { $0 === coordinator }
    showLogin()
  }
}

extension AppCoordinator: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    print("Login username: \(username)")
    dependencies.sessionProvider.session = Session(user: User(username: username))
    showHome(username)
  }
}

extension AppCoordinator: CoordinatorLifecycleDelegate {
  func coordinatorDidFinish(_ coordinator: any Coordinator) {
    childCoordinators.removeAll { $0 === coordinator }
  }
}
