//
//  PurchaseCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

class PurchaseCoordinator: Coordinator {

  var deinitHandler: ((PurchaseCoordinator) -> Void)?
  var result: String = "-"

  let rootViewController: UIViewController

  init(rootViewController: UIViewController) {
    print("\(#fileID) \(#function)")
    self.rootViewController = rootViewController
  }

  func start() {
    rootViewController.present(purchaseAlertController(), animated: true)
  }

  deinit {
    print("\(#fileID) \(#function)")
    deinitHandler?(self)
  }

  // MARK: - Alert Controllers

  func purchaseAlertController() -> CoordinatedAlertController {
    let alert = CoordinatedAlertController(title: "Purchase flow", message: "Do you want to purchase?", preferredStyle: .alert)
    alert.object = self
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.rootViewController.present(self.confirmationAlertController(), animated: true)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    return alert
  }

  func confirmationAlertController() -> CoordinatedAlertController {
    let alert = CoordinatedAlertController(title: "Purchase flow", message: "Are you sure?", preferredStyle: .alert)
    alert.object = self
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    return alert
  }

}

class CoordinatedAlertController: UIAlertController {
  var object: AnyObject?
}
