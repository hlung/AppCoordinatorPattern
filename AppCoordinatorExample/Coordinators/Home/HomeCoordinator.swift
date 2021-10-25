import UIKit

/// An example of a coordinator that manages main content of the app.
final class HomeCoordinator: ChildCoordinator {

  var delegate: ChildCoordinatorDelegate?
  let window: UIWindow
  private lazy var navigationController = UINavigationController()

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

  func start() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemGray3
    navigationController.navigationBar.scrollEdgeAppearance = appearance

    let viewController = HomeViewController()
    navigationController.setViewControllers([viewController], animated: false)
    window.rootViewController = navigationController

    viewController.logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    viewController.purchaseButton.addTarget(self, action: #selector(purchaseButtonDidTap), for: .touchUpInside)
  }

  @objc func logoutButtonDidTap() {
    stop()
  }

  @objc func purchaseButtonDidTap() {
    AppCoordinator.shared.showPurchase()
  }

}
