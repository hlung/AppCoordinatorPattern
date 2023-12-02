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
  private var childCoordinators: [AnyObject] = []

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

  func showHome(_ session: Session) {
    let coordinator = HomeCoordinator(navigationController: rootViewController, username: session.user.username)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showLogin() {
    Task { @MainActor in
      let coordinator = LoginAsyncCoordinator(navigationController: rootViewController)
      let username = await coordinator.start()
      let session = Session(user: User(username: username))
      dependencies.sessionProvider.session = session
      showHome(session)
    }
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    dependencies.sessionProvider.session = nil
    childCoordinators.removeAll { $0 === coordinator }
    showLogin()
  }
}
