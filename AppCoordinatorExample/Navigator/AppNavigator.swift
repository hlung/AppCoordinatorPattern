import UIKit

/// Benefits:
/// - navigation validation - e.g. do nothing if a page is already open, or blocks all navigation completely when app is not ready
/// - navigation redirection - e.g. show log in page for certain actions
/// - keep track of navigation history - e.g. keep track of previous screen for analytics purposes
@MainActor final class AppNavigator {

  private let window: UIWindow

  init(window: UIWindow) {
    self.window = window

    // Note:
    // Need to set a dummy view controller to window.rootViewController here because
    // in coordinator.start(), where the correct viewController is set up, is an async task.
    // App will crash if rootViewController at the end of application didFinishLaunchingWithOptions.
    // It will be briefly visible, which should be ok for demo purpose.
    // In a real production app, you may want to handle this more gracefully.
    let dummyViewController = UIViewController()
    window.rootViewController = dummyViewController
    window.makeKeyAndVisible()
  }

  func start() {
    if UserDefaults.standard.isLoggedIn {
      perform(.home)
    }
    else {
      perform(.login)
    }
  }

  func perform(_ navigation: Navigation) {
    switch navigation {
    case .home:
      Task {
        let coordinator = HomeCoordinator(window: window)
        try? await coordinator.start()

        // When HomeCoordinator ends, it means we have logged out.
        UserDefaults.standard.isLoggedIn = false
        start()
      }

    case .login:
      Task {
        let coordinator = LoginCoordinator(window: window)
        let result = try? await coordinator.start()

        // When LoginCoordinator ends, it means we have successfully logged in.
        print("Login result: \(String(describing: result))")
        UserDefaults.standard.isLoggedIn = true
        start()
      }

    case .purchase:
      Task {
        guard let viewController = window.rootViewController else { return }
        let coordinator = PurchaseCoordinator(rootViewController: viewController)
        let result = try? await coordinator.start()

        // Use the result. Here we just print it.
        print("Purchase result: \(String(describing: result))")
      }
    }
  }

}
