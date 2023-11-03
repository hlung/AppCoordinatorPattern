import UIKit

protocol HomeViewControllerDelegate: AnyObject {
  func homeViewControllerDidAppear(_ viewController: HomeViewController)
  func homeViewControllerDidLogOut(_ viewController: HomeViewController)
  func homeViewControllerPurchase(_ viewController: HomeViewController)
  func homeViewControllerDidTapOnboarding(_ viewController: HomeViewController)
}

class HomeViewController: UIViewController {

  weak var delegate: HomeViewControllerDelegate?

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
    label.text = "Welcome! \(UserDefaults.standard.loggedInUsername ?? "-")"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var onboardingButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Show onboarding", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGreen
    button.setTitleColor(.black, for: .highlighted)
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    return button
  }()

  lazy var purchaseSVODButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Purchase SVOD", for: .normal)
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
    stackView.addArrangedSubview(onboardingButton)
    stackView.addArrangedSubview(purchaseSVODButton)
    stackView.addArrangedSubview(logOutButton)
    stackView.addArrangedSubview(UIView())

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])

    logOutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    purchaseSVODButton.addTarget(self, action: #selector(purchaseSVODButtonDidTap), for: .touchUpInside)
    onboardingButton.addTarget(self, action: #selector(onboardingButtonDidTap), for: .touchUpInside)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    delegate?.homeViewControllerDidAppear(self)
  }

  @objc func onboardingButtonDidTap() {
    delegate?.homeViewControllerDidTapOnboarding(self)
  }

  @objc func logoutButtonDidTap() {
    delegate?.homeViewControllerDidLogOut(self)
  }

  @objc func purchaseSVODButtonDidTap() {
    delegate?.homeViewControllerPurchase(self)
  }

}

