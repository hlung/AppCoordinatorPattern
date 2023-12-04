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
    showFakeSplash()
    dependencies.sessionProvider.loadSavedSession()

    Task { @MainActor in
      let _ = try await dependencies.appLaunchDataProvider.getAppLaunchData()

      // Using `while true` loop here may look scary, but there's actually an infinite loop
      // between logged in and logged out state. So this hilights that exact behavior clearly.
      // We could put showHomePage at the end of showLoginPage (and vice versa), but it kinda violates SRP
      // by doing 2 things in one func. And it kinda hides that infinite loop. So I prefer this approach.
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
