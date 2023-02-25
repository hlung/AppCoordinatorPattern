import Foundation

protocol ParentCoordinator: AnyObject {
  var children: [AnyObject] { get set }

  func start()
}

protocol ChildCoordinator: AnyObject {
  var teardown: ((Self) -> Void)? { get set }

  func start()
}

extension ChildCoordinator {
  func stop() {
    teardown?(self)
  }
}
