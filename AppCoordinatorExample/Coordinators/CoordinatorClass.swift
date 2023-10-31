import UIKit

class CoordinatorClass {

  let rootViewController: UIViewController
  var children: [CoordinatorClass] = []
  weak var parent: CoordinatorClass?

  init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
  }

  func didMove(toParent coordinator: CoordinatorClass?) {

  }

  func addChild(_ coordinator: CoordinatorClass) {
    children.append(coordinator)
    coordinator.parent = self
  }

  func removeFromParent() {
    parent?.children.removeAll(where: { $0 === self })
    parent = nil
  }

}
