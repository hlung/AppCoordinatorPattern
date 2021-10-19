import UIKit

class LoginViewController: UIViewController {

  weak var coordinator: LoginNavigationController?

  lazy var button: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log In", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    return button
  }()

  lazy var cancelButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Cancel", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGray
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(button)
    view.addSubview(cancelButton)

    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      button.widthAnchor.constraint(equalToConstant: 200),
      cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
      cancelButton.widthAnchor.constraint(equalToConstant: 200),
    ])
  }

  @objc func buttonDidTap() {
    coordinator?.finish(result: "Log In")
  }

  @objc func cancelButtonDidTap() {
    coordinator?.reset()
  }

}

