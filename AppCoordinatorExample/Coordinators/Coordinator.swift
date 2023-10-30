import UIKit

protocol Coordinator: AnyObject {
  var window: UIWindow { get } // This can be rootViewController. But for this demo purpose, it's easier to just use window.

  func start()
}

protocol ParentCoordinator: Coordinator {
  var children: [any Coordinator] { get set }
}

extension ParentCoordinator {
  func addChild(_ coordinator: any Coordinator) {
    coordinator.start()
    children.append(coordinator)
  }
}
