import UIKit

/// An example of a coordinator that manages main content of the app.
@MainActor final class HomeCoordinator: Coordinator {

  let window: UIWindow
  private lazy var navigationController = UINavigationController()
  private var continuation: CheckedContinuation<Void, Error>?

  init(window: UIWindow) {
    print("\(type(of: self)) \(#function)")
    self.window = window
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  func start() async throws {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemGray3
    navigationController.navigationBar.scrollEdgeAppearance = appearance

    let viewController = HomeViewController()
    viewController.delegate = self
    navigationController.setViewControllers([viewController], animated: false)
    window.rootViewController = navigationController

    try await withCheckedThrowingContinuation { self.continuation = $0 }
  }

}

extension HomeCoordinator: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    continuation?.resume(returning: ())
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    Task {
      guard let viewController = window.rootViewController else { return }
      let coordinator = PurchaseCoordinator(rootViewController: viewController)
      let result = try? await coordinator.start()

      // Use the result. Here we just print it.
      print("Purchase result: \(String(describing: result))")
    }
  }
}
