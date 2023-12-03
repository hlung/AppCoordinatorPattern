import Foundation
import UIKit

class FakeSplashViewController: UIViewController {

  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    return stackView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Fake splash"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var activityIndicator: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.startAnimating()
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .lightGray
    view.addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(activityIndicator)

    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])
  }

}
