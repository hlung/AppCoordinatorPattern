//
//  PurchaseCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

/// For demonstrating a coordinator that is not a UIViewController subclass by itself.
/// This means UIKit presentation stack cannot hold on to the coordinator anymore.
/// We solve this by passing on the coorinator reference to the things that will actually get into the UIKit presentation stack, which is the alert controllers.
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
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    return alert
  }

  func confirmationAlertController() -> CoordinatedAlertController {
    let alert = CoordinatedAlertController(title: "Purchase flow", message: "Are you sure?", preferredStyle: .alert)
    alert.retainedCoordinator = self
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    return alert
  }

}
