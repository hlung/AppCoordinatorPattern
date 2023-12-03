import UIKit

final class AppCoordinator {

  struct Dependencies {
    let sessionProvider: SessionProvider
    let appLaunchDataProvider: AppLaunchDataProvider
  }

  let rootViewController: UINavigationController
  let dependencies: Dependencies

  init(navigationController: UINavigationController, dependencies: Dependencies) {
    self.rootViewController = navigationController
    self.dependencies = dependencies
  }

  func start() {
    Task { @MainActor in
      showFakeSplash()

      dependencies.sessionProvider.loadSavedSession()
      let _ = try await dependencies.appLaunchDataProvider.getAppLaunchData()

      // Using `while true` loop here may look scary, but I think it shows a clear intent
      // that there's a loop here between logged in and logged out state.
      // If we put showHomePage at the end of showLoginPage, it works but it kinda violates SRP
      // by doing 2 things in one func.
      while true {
        if let session = dependencies.sessionProvider.session {
          await showHomePage(session)
          dependencies.sessionProvider.session = nil
        }
        else {
          let session = await showLoginPage()
          dependencies.sessionProvider.session = session
        }
      }
    }
  }

  // MARK: - Navigation

  private func showFakeSplash() {
    let viewController = FakeSplashViewController()
    rootViewController.viewControllers = [viewController]
  }

  private func showHomePage(_ session: Session) async {
    let coordinator = HomeAsyncCoordinator(navigationController: rootViewController, session: session)
    await coordinator.start()
  }

  private func showLoginPage() async -> Session {
    let coordinator = LoginAsyncCoordinator(navigationController: rootViewController)
    let username = await coordinator.start()
    return Session(user: User(username: username))
  }

}
