import UIKit

protocol Coordinator: AnyObject {
  // This can be just a rootViewController. But for this demo purpose, it's easier to just use window.
  // A window also has a rootViewController, so it kinda works for now.
  var window: UIWindow { get }

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
