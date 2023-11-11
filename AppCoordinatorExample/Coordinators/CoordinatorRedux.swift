import UIKit

// A protocol that acts as a guideline for how a coordinator should look like.
protocol CoordinatorRedux: AnyObject where ViewController: UIViewController {
  associatedtype ViewController
  associatedtype State
  associatedtype Action

  var rootViewController: ViewController { get }
  var state: State { get }

  func start()
  func send(_ action: Action)
}
