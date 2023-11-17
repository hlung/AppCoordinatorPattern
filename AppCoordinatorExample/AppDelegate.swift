import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private(set) var coordinator: AnyObject!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    let navigationController = UINavigationController()

    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemGray3
    navigationController.navigationBar.scrollEdgeAppearance = appearance

    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    let coordinator = AppCoordinator(navigationController: navigationController)
//    let coordinator = AppAsyncCoordinator(navigationController: navigationController)
//    let coordinator = AppCoordinatorRedux(navigationController: navigationController, dependencies: UserDefaults.standard)
    coordinator.start()

    self.coordinator = coordinator

    return true
  }

}

