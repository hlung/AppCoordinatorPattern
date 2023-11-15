import UIKit

final class AppCoordinatorReduxNested: CoordinatorRedux, ActionSender {

  typealias Dependencies = UsernameProvider

  // All possible states of the coordinator.
  // Pros
  // - create a common domain model language to help with communication
  // - help with discovery and debugging
  // Can be any type, not just struct or enum.
  // - Leave as internal to allow testing.
  // - This is meant to be just a "rough" overview of view state.
  //   This is not meant to capture exact all navigation/modal stack. UIKit doesn't provide nice way to detect
  //   when vc are popped/dismissed, so ultimate view source of truth is still in UIKit itself.
  enum State: Equatable {
    case fakeSplash(loadingData: Bool)
    case loggedOut
    case loggedIn(username: String)
    // case error
    // case forcedUpdate
  }

  // All possible actions that can mutate state.
  // - I like it because all logic to update state will be in one place (in send() func).
  // Alternatives:
  // - use functions + protocols: we can give child coordinators partial access to actions via a protocol, eliminating need for delegate. But state update won't be in one place (in send() func) anymore, and we can't capture action as objects which may be handy for deeplinking, state restoration, etc..
  enum Action {
    case loadData
    case login(String)
    case logout
  }

  private(set) var state: State {
    didSet {
      guard state != oldValue else { return }
      print("[\(type(of: self))] \(#function)", oldValue, "->", state)
      translateStateToUI()
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

  func start() {
    translateStateToUI()
    send(.loadData)
  }

  // Translates state to UI
  // - Avoid sending actions or mutating states.
  func translateStateToUI() {
    switch state {
    case .fakeSplash(loadingData: let loadingData):
      let viewController = UIViewController()
      viewController.view.backgroundColor = .systemTeal
      let frame = CGRect(x: 150, y: 300, width: 100, height: 50)
      let label = UILabel(frame: frame)
      label.text = "Fake Splash"
      let indicator = UIActivityIndicatorView(style: .large)
      indicator.frame = frame.offsetBy(dx: 0, dy: 50)
      if loadingData {
        indicator.startAnimating()
      }
      else {
        indicator.stopAnimating()
      }
      viewController.view.addSubview(label)
      viewController.view.addSubview(indicator)
      rootViewController.setViewControllers([viewController], animated: false)

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
      state = .fakeSplash(loadingData: true)

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

extension AppCoordinatorReduxNested: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    childCoordinators.removeAll { $0 === coordinator }
    send(.login(username))
  }
}

extension AppCoordinatorReduxNested: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    childCoordinators.removeAll { $0 === coordinator }
    send(.logout)
  }
}
