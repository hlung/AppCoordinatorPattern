import UIKit

protocol LoginViewControllerDelegate: AnyObject {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String)
  func loginViewControllerDidCancel(_ viewController: LoginViewController)
}

class LoginViewController: UIViewController {

  weak var delegate: LoginViewControllerDelegate?

  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    return stackView
  }()

  lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username:"
    label.font = .preferredFont(forTextStyle: .headline)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var usernameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Username"
    textField.text = "John Viki"
    textField.layer.borderColor = UIColor.gray.cgColor
    textField.layer.borderWidth = 1
    return textField
  }()

  lazy var finishButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log In", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(finishButtonDidTap), for: .touchUpInside)
    return button
  }()

  lazy var backButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Back", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGray
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(stackView)
    stackView.addArrangedSubview(usernameLabel)
    stackView.addArrangedSubview(usernameTextField)
    stackView.addArrangedSubview(finishButton)
    stackView.addArrangedSubview(backButton)
    stackView.addArrangedSubview(UIView())

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])

    for view in stackView.arrangedSubviews {
      view.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
  }

  @objc func finishButtonDidTap() {
    guard let username = usernameTextField.text, !username.isEmpty else { return }
    delegate?.loginViewController(self, didLogInWith: username)
  }

  @objc func backButtonDidTap() {
    delegate?.loginViewControllerDidCancel(self)
  }

}

