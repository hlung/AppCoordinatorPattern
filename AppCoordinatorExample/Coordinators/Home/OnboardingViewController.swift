import Foundation
import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
  func onboardingViewControllerDidFinish(_ viewController: OnboardingViewController)
}

class OnboardingViewController: UIViewController {

  weak var delegate: OnboardingViewControllerDelegate?
  var deinitHandler: () -> Void = {}

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
    label.text = "Onboarding!"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var finishButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Finish", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGreen
    button.setTitleColor(.black, for: .highlighted)
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    return button
  }()

  lazy var logOutButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log Out", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemRed
    button.setTitleColor(.black, for: .highlighted)
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(finishButton)
    stackView.addArrangedSubview(UIView())

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])

    finishButton.addTarget(self, action: #selector(finishButtonDidTap), for: .touchUpInside)
  }

  deinit {
    deinitHandler()
  }

  @objc func finishButtonDidTap() {
    delegate?.onboardingViewControllerDidFinish(self)
  }

}

