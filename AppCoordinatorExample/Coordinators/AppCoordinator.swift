import UIKit

@MainActor final class AppCoordinator {

  private var window: UIWindow!

//  var children = [any Coordinator]()

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    window.makeKeyAndVisible()

    if UserDefaults.standard.isLoggedIn {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome() {
    // Note: coordinator.start(), where window.rootViewController is set up,
    // has to be outside Task. Otherwise app will crash because window has no
    // rootViewController at the end of application didFinishLaunchingWithOptions.

    let coordinator = HomeCoordinator(window: window)
    coordinator.start()

    Task {
      try? await coordinator.result()
      UserDefaults.standard.isLoggedIn = false
      showLogin()
    }

//    coordinator.delegate = self
//    coordinator.teardown = { [weak self] coordinator in
//      UserDefaults.standard.isLoggedIn = false
//      self?.showLogin()
//      self?.children.removeAll(where: { $0 === coordinator })
//    }
//    coordinator.start()
//    children.append(coordinator)
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    coordinator.start()

    Task {
      let result = try? await coordinator.result()
      print("Login result: \(String(describing: result))")
      UserDefaults.standard.isLoggedIn = true
      showHome()
    }

//    let coordinator = LoginCoordinator(window: window)
//    coordinator.teardown = { [weak self] coordinator in
//      print("Login result: \(coordinator.result)")
//      UserDefaults.standard.isLoggedIn = true
//      self?.showHome()
//      self?.children.removeAll(where: { $0 === coordinator })
//    }
//    coordinator.start()
//    children.append(coordinator)
  }

  func showPurchase() {
//    guard let viewController = window.rootViewController else { return }
//    let coordinator = PurchaseCoordinator(presenterViewController: viewController)
//    coordinator.teardown = { [weak self] coordinator in
//      print("Purchase result: \(coordinator.result)")
//      self?.children.removeAll(where: { $0 === coordinator })
//    }
//    coordinator.start()
//    children.append(coordinator)
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator) {
    showPurchase()
  }
}
