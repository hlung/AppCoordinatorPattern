import UIKit

protocol HomeViewControllerDelegate: AnyObject {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController)
  func homeViewControllerPurchase(_ viewController: HomeViewController)
}

class HomeViewController: UIViewController {

  weak var delegate: HomeViewControllerDelegate?

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Welcome! \(UserDefaults.standard.loggedInUsername ?? "-")"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var logOutButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log Out", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemRed
    button.setTitleColor(.black, for: .highlighted)
    return button
  }()

  lazy var purchaseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Start Purchase flow", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGreen
    button.setTitleColor(.black, for: .highlighted)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    view.addSubview(logOutButton)
    view.addSubview(purchaseButton)

    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),

      logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      logOutButton.widthAnchor.constraint(equalToConstant: 200),

      purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      purchaseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
      purchaseButton.widthAnchor.constraint(equalToConstant: 200),
    ])

    logOutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    purchaseButton.addTarget(self, action: #selector(purchaseButtonDidTap), for: .touchUpInside)
  }

  @objc func logoutButtonDidTap() {
    delegate?.homeViewControllerDidLogOut(self)
  }

  @objc func purchaseButtonDidTap() {
    delegate?.homeViewControllerPurchase(self)
  }

}

