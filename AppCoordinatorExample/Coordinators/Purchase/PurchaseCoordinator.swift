//
//  PurchaseCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

/// ⚠️ This is still experimental ⚠️
/// For demonstrating a coordinator that is not a UIViewController subclass by itself.
/// This means we cannot use the presentation stack to retain it.
/// If there will be always some view controller presented during the coordinator's life time, we can pass on the coordinator to those view controllers to retain it.
/// This way we can still put stop() in deinit.
class PurchaseCoordinator: Coordinator {

  var stop: ((PurchaseCoordinator) -> Void)?
  var result: String = "-"

  let viewController: UIViewController

  init(viewController: UIViewController) {
    print("\(#fileID) \(#function)")
    self.viewController = viewController
  }

  func start() {
    viewController.present(purchaseAlertController(), animated: true)
  }

  deinit {
    print("\(#fileID) \(#function)")
    stop?(self)
  }

  // MARK: - Alert Controllers

  func purchaseAlertController() -> CoordinatedAlertController {
    let alert = CoordinatedAlertController(title: "Purchase flow", message: "Do you want to purchase?", preferredStyle: .alert)
    alert.retainedCoordinator = self
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.viewController.present(self.confirmationAlertController(), animated: true)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.result = "Not purchased"
    }))
    return alert
  }

  func confirmationAlertController() -> CoordinatedAlertController {
    let alert = CoordinatedAlertController(title: "Purchase flow", message: "Are you sure?", preferredStyle: .alert)
    alert.retainedCoordinator = self
    alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
      self.result = "Purchased"
    }))
    alert.addAction(UIAlertAction(title: "Yes!", style: .cancel, handler: { _ in
      self.result = "Not purchased"
    }))
    return alert
  }

}
