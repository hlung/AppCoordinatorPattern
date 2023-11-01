import UIKit

/**
 What is a coordinator?
 "A coordinator is an object that bosses one or more view controllers around.
 Taking all of the driving logic out of your view controllers."
 - from https://khanlou.com/2015/10/coordinators-redux/
 */
protocol Coordinator: AnyObject where ViewController: UIViewController {
  associatedtype ViewController
  var rootViewController: ViewController { get }
  func start()
}

protocol ParentCoordinator: Coordinator {
  var childCoordinators: [any Coordinator] { get set }
}
