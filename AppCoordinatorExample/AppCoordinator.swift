import UIKit

final class AppCoordinator {

  class Dependencies {
    let sessionProvider: SessionProvider
    let appLaunchDataProvider: AppLaunchDataProvider

    init(sessionProvider: SessionProvider, appLaunchDataProvider: AppLaunchDataProvider) {
      self.sessionProvider = sessionProvider
      self.appLaunchDataProvider = appLaunchDataProvider
    }
  }

  let rootViewController: UINavigationController
  let dependencies: Dependencies

  init(navigationController: UINavigationController, dependencies: Dependencies) {
    self.rootViewController = navigationController
    self.dependencies = dependencies
  }

  func start() {
    dependencies.sessionProvider.loadSavedSession()

    if let session = dependencies.sessionProvider.session {
      showHome(session)
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  private func showHome(_ session: Session) {
    Task { @MainActor in
      let coordinator = HomeAsyncCoordinator(navigationController: rootViewController, username: session.user.username)
      await coordinator.start()
      dependencies.sessionProvider.session = nil
      showLogin()
    }
  }

  private func showLogin() {
    Task { @MainActor in
      let coordinator = LoginAsyncCoordinator(navigationController: rootViewController)
      let username = await coordinator.start()
      let session = Session(user: User(username: username))
      dependencies.sessionProvider.session = session
      showHome(session)
    }
  }

}
