import UIKit

protocol PurchaseCoordinatorDelegate: AnyObject {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator)
  func purchaseCoordinatorDidCancel(_ coordinator: PurchaseCoordinator)
}

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseCoordinator: Coordinator {

  weak var delegate: PurchaseCoordinatorDelegate?
  weak var parentCoordinator: ParentCoordinator?

  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    print("\(type(of: self)) \(#function)")
    self.navigationController = navigationController
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  func start() {
    self.navigationController.present(purchaseAlertController(), animated: true)
  }

  // MARK: - Alert Controllers

  func purchaseAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow 1", message: "Do you want to purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.delegate?.purchaseCoordinatorDidCancel(self)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.navigationController.present(self.confirmationAlertController(), animated: true)
    }))
    return alert
  }

  func confirmationAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow 2", message: "Do you really really really want to purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.delegate?.purchaseCoordinatorDidCancel(self)
    }))
    alert.addAction(UIAlertAction(title: "Yes!", style: .default, handler: { _ in
      self.navigationController.present(self.purchasedAlertController(), animated: true)
    }))
    return alert
  }

  func purchasedAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow 3", message: "All set!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.delegate?.purchaseCoordinatorDidPurchase(self)
    }))
    return alert
  }

}
