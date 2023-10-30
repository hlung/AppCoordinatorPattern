import UIKit

protocol Coordinator: AnyObject {
  // This can be just a rootViewController. But for this demo purpose, it's easier to just use window.
  // A window also has a rootViewController, so it kinda works for now.
  var window: UIWindow { get }

  // Optional because this is weak
  var parentCoordinator: ParentCoordinator? { get set }

  func start()
}

extension Coordinator {
  // Putting removal in child instead of parent to mimic how a UIViewController removes its child.
  // This requires saving parentCoordinator in Coordinator, which add some more code,
  // but I like the removal code this way more. So let's try this.
  func removeFromParent() {
    parentCoordinator?.children.removeAll(where: { $0 === self })
    parentCoordinator = nil
  }
}

protocol ParentCoordinator: AnyObject {
  var children: [any Coordinator] { get set }
}

extension ParentCoordinator {
  func addChild(_ coordinator: any Coordinator) {
    children.append(coordinator)
    coordinator.parentCoordinator = self
    coordinator.start()
  }
}
