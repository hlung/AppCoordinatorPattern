import UIKit

final class AppCoordinatorRedux: CoordinatorRedux {

  typealias Dependencies = UsernameProvider

  // All possible states of the coordinator.
  // Can be any type, not just struct or enum.
  // - Leave as internal to allow testing.
  enum State: Equatable {
    case fakeSplash(loadingData: Bool)
    case loggedOut
    case loggedIn(username: String)
    // case error
    // case forcedUpdate
  }

  // All possible actions that can mutate state
  enum Action {
    case loadData
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
    self.state = .fakeSplash(loadingData: false)
  }

  // Translates state to UI
  func start() {
    switch state {
    case .fakeSplash(loadingData: let loadingData):
      if !loadingData {

        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemTeal
        let frame = CGRect(x: 150, y: 300, width: 100, height: 50)
        let label = UILabel(frame: frame)
        label.text = "Fake Splash"
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.frame = frame.offsetBy(dx: 0, dy: 50)
        indicator.startAnimating()
        viewController.view.addSubview(label)
        viewController.view.addSubview(indicator)
        rootViewController.setViewControllers([viewController], animated: false)

        self.send(.loadData)
      }

    case .loggedIn(username: let username):
      let coordinator = HomeCoordinator(navigationController: rootViewController, username: username)
      childCoordinators.append(coordinator)
      coordinator.delegate = self
      coordinator.start()

    case .loggedOut:
      let coordinator = LoginCoordinator(navigationController: rootViewController)
      childCoordinators.append(coordinator)
      coordinator.delegate = self
      coordinator.start()
    }
  }

  // Translates action to state, update dependencies, and may send additional actions.
  // - This should be the only place state is updated.
  // - This can be made a pure function, but not doing so to keep it simple for now.
  func send(_ action: Action) {
    switch action {
    case .loadData:
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        if let username = self.dependencies.loggedInUsername {
          self.send(.login(username))
        }
        else {
          self.send(.logout)
        }
      }

    case .login(let username):
      dependencies.loggedInUsername = username
      state = .loggedIn(username: username)

    case .logout:
      dependencies.loggedInUsername = nil
      dependencies.clear()
      state = .loggedOut
    }
  }

}

// Send actions
extension AppCoordinatorRedux: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    childCoordinators.removeAll { $0 === coordinator }
    send(.login(username))
  }
}

extension AppCoordinatorRedux: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    childCoordinators.removeAll { $0 === coordinator }
    send(.logout)
  }
}
