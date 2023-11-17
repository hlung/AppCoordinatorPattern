import UIKit

final class AppAsyncCoordinator: ParentAsyncCoordinator {

  let rootViewController: UINavigationController
  var childAsyncCoordinators: [any AsyncCoordinator] = []

  init(navigationController: UINavigationController) {
    self.rootViewController = navigationController
  }

  func start() {
    Task { @MainActor in
      while true {
        if UserDefaults.standard.isLoggedIn {
          try? await showHome()
        }
        else {
          try? await showLogin()
        }
      }
    }
  }

  func start(string: String) -> Void {

  }

  // MARK: - Navigation

  func showHome() async throws {
    let coordinator = HomeAsyncCoordinator(navigationController: rootViewController)
    try await start(coordinator)
    UserDefaults.standard.clear()
  }

  func showLogin() async throws {
    let coordinator = LoginAsyncCoordinator(navigationController: rootViewController)
    UserDefaults.standard.loggedInUsername = try await start(coordinator)
  }

}
