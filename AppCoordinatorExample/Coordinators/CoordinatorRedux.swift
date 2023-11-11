import UIKit

// A protocol that acts as a guideline for how a coordinator should look like.
protocol CoordinatorRedux: AnyObject where ViewController: UIViewController {
  associatedtype State
  associatedtype Action
  associatedtype ViewController

  var state: State { get }
  var rootViewController: ViewController { get }

  func start()
  func send(_ action: Action)
}
