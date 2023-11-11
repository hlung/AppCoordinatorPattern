import UIKit

final class AppCoordinator {

  typealias Dependencies = UsernameProvider

  private struct State {
    var loggedInUsername: String?
  }

  enum Action {
    case login(String)
    case logout
  }

  private var state: State {
    didSet {
      start()
    }
  }

  let rootViewController: UINavigationController
  var childCoordinators: [any Coordinator] = []
  var dependencies: Dependencies

  init(navigationController: UINavigationController, dependencies: Dependencies) {
    self.dependencies = dependencies
    self.rootViewController = navigationController
    self.state = State(loggedInUsername: dependencies.loggedInUsername)
  }

  func start() {
    if let _ = state.loggedInUsername {
      let coordinator = HomeCoordinator(navigationController: rootViewController)
      childCoordinators.append(coordinator)
      coordinator.appCoordinator = self
      coordinator.start()
    }
    else {
      let coordinator = LoginCoordinator(navigationController: rootViewController)
      childCoordinators.append(coordinator)
      coordinator.appCoordinator = self
      coordinator.start()
    }
  }

  // The only place where state can be mutated
  func send(_ action: Action) {
    switch action {
    case .login(let string):
      childCoordinators.removeAll()
      dependencies.loggedInUsername = string
      state.loggedInUsername = string
    case .logout:
      childCoordinators.removeAll()
      dependencies.clear()
      state.loggedInUsername = nil
    }
  }

}
