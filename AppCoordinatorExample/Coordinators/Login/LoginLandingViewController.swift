import UIKit

protocol LoginLandingViewControllerDelegate: AnyObject {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController)
}

class LoginLandingViewController: UIViewController {

  weak var delegate: LoginLandingViewControllerDelegate?

  lazy var logInButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log In", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)
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

    NSLayoutConstraint.activate([
      logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      logInButton.widthAnchor.constraint(equalToConstant: 200),
    ])
  }

  @objc func logInButtonDidTap() {
    delegate?.loginLandingViewControllerDidSelectLogin(self)
  }

}

