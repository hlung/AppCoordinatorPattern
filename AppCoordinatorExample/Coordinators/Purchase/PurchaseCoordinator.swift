import UIKit

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseCoordinator: ChildCoordinator {

  enum PurchaseResult {
    case unknown
    case cancelled
    case success
  }

  var teardown: ((PurchaseCoordinator) -> Void)?

  var result: PurchaseResult = .unknown
  let presenterViewController: UIViewController

  init(presenterViewController: UIViewController) {
    print("\(type(of: self)) \(#function)")
    self.presenterViewController = presenterViewController
  }

  func start() {
    presenterViewController.present(purchaseAlertController(), animated: true)
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  // MARK: - Alert Controllers

  func purchaseAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow", message: "Do you want to purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.result = .cancelled
      self.presenterViewController.present(self.purchaseResultAlertController("Purchase Cancelled"), animated: true)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.result = .success
      self.presenterViewController.present(self.purchaseResultAlertController("Purchase Success"), animated: true)
    }))
    return alert
  }

  func purchaseResultAlertController(_ title: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.stop()
    }))
    return alert
  }

}
