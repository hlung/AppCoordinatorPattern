import UIKit

protocol Coordinator: AnyObject {
  associatedtype ViewController: UIViewController
  associatedtype Output

  var rootViewController: ViewController { get }
  func start() async throws -> Output
}
