import Foundation

protocol ParentCoordinator: AnyObject {
  var children: [AnyObject] { get set }

  func start()
}
