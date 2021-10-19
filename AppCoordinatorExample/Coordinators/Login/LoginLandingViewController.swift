import UIKit

class LoginLandingViewController: UIViewController {

  weak var coordinator: LoginNavigationController?

  lazy var logInButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log In", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)
    return button
  }()

  lazy var signUpButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Sign Up", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
    return button
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(logInButton)
    view.addSubview(signUpButton)

    NSLayoutConstraint.activate([
      logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      logInButton.widthAnchor.constraint(equalToConstant: 200),

      signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
      signUpButton.widthAnchor.constraint(equalToConstant: 200),
    ])

    let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTap))
    navigationItem.leftBarButtonItems = [item]
  }

  @objc func cancelButtonDidTap() {
    coordinator?.cancel()
  }

  @objc func logInButtonDidTap() {
    coordinator?.showLoginPage()
  }

  @objc func signUpButtonDidTap() {
    coordinator?.showSignUpPage()
  }

}

