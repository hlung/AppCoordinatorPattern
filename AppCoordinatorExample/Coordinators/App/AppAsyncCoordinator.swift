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

  // MARK: - Navigation

  func showHome() async throws {
    let coordinator = HomeAsyncCoordinator(navigationController: rootViewController)
    try await start(coordinator)
    clearUserDefaults()
  }

  func showLogin() async throws {
    let coordinator = LoginAsyncCoordinator(navigationController: rootViewController)
    UserDefaults.standard.loggedInUsername = try await start(coordinator)
  }

  func clearUserDefaults() {
    UserDefaults.standard.loggedInUsername = nil
    UserDefaults.standard.onboardingShown = false
    UserDefaults.standard.consent = nil
  }

}
