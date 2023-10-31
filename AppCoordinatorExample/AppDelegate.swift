import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private(set) var coordinator: AppCoordinator!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    let navigationController = UINavigationController()
    window.rootViewController = navigationController

    self.coordinator = AppCoordinator(navigationController: navigationController)
    coordinator.start()
    window.makeKeyAndVisible()

    return true
  }

}

