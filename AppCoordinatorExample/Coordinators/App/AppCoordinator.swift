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

  func start() /*-> Task<Void, Never>*/ {
    Task {
      if let username = dependencies.loggedInUsername {
        showHome(username)
      }
      else {
        await showLoginAsync()
      }
    }
  }

  // MARK: - Navigation

  func showHome(_ username: String) {
    let coordinator = HomeCoordinator(navigationController: rootViewController, username: username)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  @MainActor
  func showLogin() {
    let coordinator = LoginCoordinator(navigationController: rootViewController)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  @MainActor
  func showLoginAsync() async {
    let coordinator = LoginAsyncCoordinator(navigationController: rootViewController)
    childCoordinators.append(coordinator)
    let username = await coordinator.start()
    childCoordinators.removeAll { $0 === coordinator }
    dependencies.loggedInUsername = username
    showHome(username)
  }
}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    dependencies.clear()
    childCoordinators.removeAll { $0 === coordinator }
    Task { await showLoginAsync() }
  }
}

extension AppCoordinator: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    print("Login result: \(username)")
    dependencies.loggedInUsername = username
    childCoordinators.removeAll { $0 === coordinator }
    showHome(username)
//    showHome(username)
  }
}

extension AppCoordinator: CoordinatorLifecycleDelegate {
//  func coordinatorDidFinish<C>(_ coordinator: C, with output: C.Output) where C : Coordinator {
  func coordinatorDidFinish(_ coordinator: any Coordinator) {
    childCoordinators.removeAll { $0 === coordinator }
  }
}
