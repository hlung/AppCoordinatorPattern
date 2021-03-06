import UIKit

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseCoordinator: ChildCoordinator {

  var teardown: ((PurchaseCoordinator) -> Void)?

  var result: String = "Cancelled"
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
      self.stop()
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.presenterViewController.present(self.confirmationAlertController(), animated: true)
    }))
    return alert
  }

  func confirmationAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow", message: "Confirm purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.stop()
    }))
    alert.addAction(UIAlertAction(title: "Yes!", style: .default, handler: { _ in
      self.result = "Purchased"
      self.stop()
    }))
    return alert
  }

}
