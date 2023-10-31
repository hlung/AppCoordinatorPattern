import UIKit

protocol Coordinator: AnyObject {
  func start()
}

protocol ParentCoordinator: Coordinator {
  var children: [any Coordinator] { get set }
}

extension ParentCoordinator {
  func addChild(_ coordinator: any Coordinator) {
    children.append(coordinator)
  }

  func removeChild(_ coordinator: any Coordinator) {
    children.removeAll(where: { $0 === self })
  }
}
