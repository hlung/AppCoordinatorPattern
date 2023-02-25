import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private(set) var coordinator: AppCoordinator!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    self.coordinator = AppCoordinator(window: window)
    self.coordinator.start()

    return true
  }

}

