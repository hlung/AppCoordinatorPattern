import UIKit

class SignUpViewController: UIViewController {

  weak var coordinator: LoginNavigationController?

  lazy var button: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Sign Up", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(button)

    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      button.widthAnchor.constraint(equalToConstant: 200),
    ])
  }

  @objc func buttonDidTap() {
    coordinator?.finish(success: true)
  }
}

