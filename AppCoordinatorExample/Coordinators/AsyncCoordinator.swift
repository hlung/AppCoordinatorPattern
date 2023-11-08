import UIKit

protocol AsyncCoordinator: AnyObject where ViewController: UIViewController {
  associatedtype ViewController
  associatedtype Output

  var rootViewController: ViewController { get }
  func start() async throws -> Output
}
