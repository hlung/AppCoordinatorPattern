import UIKit

/**
 What is a coordinator?
 "A coordinator is an object that bosses one or more view controllers around.
 Taking all of the driving logic out of your view controllers."
 - from https://khanlou.com/2015/10/coordinators-redux/
 */
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
