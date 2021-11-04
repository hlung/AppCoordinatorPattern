import Foundation

protocol ChildCoordinator: AnyObject {
  var teardown: ((Self) -> Void)? { get set }

  func start()
}

extension ChildCoordinator {
  func stop() {
    teardown?(self)
  }
}
