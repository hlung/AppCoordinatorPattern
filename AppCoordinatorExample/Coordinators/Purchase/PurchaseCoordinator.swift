//
//  PurchaseCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class PurchaseCoordinator: Coordinator {

  var completion: ((PurchaseCoordinator) -> Void)?
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
      self.completion?(self)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.presenterViewController.present(self.confirmationAlertController(), animated: true)
    }))
    return alert
  }

  func confirmationAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow", message: "Confirm?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.completion?(self)
    }))
    alert.addAction(UIAlertAction(title: "Yes!", style: .default, handler: { _ in
      self.result = "Purchased"
      self.completion?(self)
    }))
    return alert
  }

}
