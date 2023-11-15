import UIKit

final class AppCoordinatorRedux: CoordinatorRedux {

  typealias Dependencies = UsernameProvider

  // Leave as internal to allow testing.
  // All possible states of the coordinator.
  // Can be any type, not just struct or enum.
  struct State: Equatable {
    var loggedInUsername: String?
    // var showFakeSplashScreen: Bool
    // var appLaunchError: Error?
    // var showForcedUpdateAlert: Bool
  }

  enum Action {
    case login(String)
    case logout
  }

  private(set) var state: State {
    didSet {
      guard state != oldValue else { return }
      start()
    }
  }

  let rootViewController: UINavigationController
  var childCoordinators: [AnyObject] = []
  private var dependencies: Dependencies

  init(navigationController: UINavigationController, dependencies: Dependencies) {
    self.dependencies = dependencies
    self.rootViewController = navigationController
    self.state = State(loggedInUsername: dependencies.loggedInUsername)
  }

  // Updates rootViewController from a clean slate using current state.
  func start() {
    if let username = state.loggedInUsername {
      let coordinator = HomeCoordinator(navigationController: rootViewController, username: username)
      childCoordinators.append(coordinator)
      coordinator.delegate = self
      coordinator.start()
    }
    else {
      let coordinator = LoginCoordinator(navigationController: rootViewController)
      childCoordinators.append(coordinator)
      coordinator.delegate = self
      coordinator.start()
    }
  }

}

extension AppCoordinatorRedux: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    childCoordinators.removeAll { $0 === coordinator }
    dependencies.loggedInUsername = username
    state.loggedInUsername = username
  }
}

extension AppCoordinatorRedux: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    childCoordinators.removeAll { $0 === coordinator }
    dependencies.loggedInUsername = nil
    dependencies.clear()
    state.loggedInUsername = nil
  }
}
