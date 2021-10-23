//
//  PurchaseCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

/** ⚠️ This is still experimental ⚠️
 For demonstrating a coordinator that is not a UIViewController subclass by itself.
 This means we cannot use the presentation stack to retain it.

 Option 1: Pass on coordinator to presented view controllers
 If there will be always some view controller presented during the coordinator's life time, we can pass coordinator to those view controllers to retain it.
 This way we can call stop() in last view controller deinit.

 Option 2:
 Another option is to create a retain cycle on purpose, and manually remove it when our coordinator ends. This is a bit risky. And it is not so different
 than the original implementation where child coordinators are held on to by AppCoordinator.
 */
class PurchaseCoordinator: Coordinator {

  var completion: ((PurchaseCoordinator) -> Void)?
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
