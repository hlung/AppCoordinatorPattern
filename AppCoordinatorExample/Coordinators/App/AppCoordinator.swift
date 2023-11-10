import UIKit

final class AppCoordinator: ParentCoordinator {

  enum State {
    case homePage
    case loginPage
  }

  enum Action {
    case login
    case logout
  }

  let rootViewController: UINavigationController
  var childCoordinators: [any Coordinator] = []

  var state: State = .loginPage {
    didSet {
      print("[\(type(of: self))] \(#function)")
      switch state {
      case .homePage:
        showHome()
      case .loginPage:
        showLogin()
      }
    }
  }

  init(navigationController: UINavigationController) {
    self.rootViewController = navigationController
  }

  func start() {
    if UserDefaults.standard.isLoggedIn {
      perform(.login)
    }
    else {
      perform(.logout)
    }
  }

  func perform(_ action: Action) {
    switch action {
    case .login:
      state = .homePage
    case .logout:
      state = .loginPage
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
    let coordinator = LoginCoordinator(navigationController: rootViewController)
    addChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showLoginAsync() {
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
    perform(.logout)
  }
}

extension AppCoordinator: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    print("Login result: \(username)")
    UserDefaults.standard.loggedInUsername = username
    removeChild(coordinator)
    perform(.login)
  }
}
