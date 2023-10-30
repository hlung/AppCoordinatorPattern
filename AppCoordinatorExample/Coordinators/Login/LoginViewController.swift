import UIKit

protocol LoginViewControllerDelegate: AnyObject {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String)
  func loginViewControllerDidCancel(_ viewController: LoginViewController)
}

class LoginViewController: UIViewController {

  weak var delegate: LoginViewControllerDelegate?

  lazy var finishButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Finish Log In", for: .normal)
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
    view.addSubview(finishButton)
    view.addSubview(backButton)

    NSLayoutConstraint.activate([
      finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      finishButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      finishButton.widthAnchor.constraint(equalToConstant: 200),

      backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
      backButton.widthAnchor.constraint(equalToConstant: 200),
    ])
  }

  @objc func finishButtonDidTap() {
    delegate?.loginViewController(self, didLogInWith: "success")
  }

  @objc func backButtonDidTap() {
    delegate?.loginViewControllerDidCancel(self)
  }

}

