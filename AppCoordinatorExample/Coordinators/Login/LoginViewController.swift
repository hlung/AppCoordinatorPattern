//
//  LoginViewController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

protocol LoginViewControlerDelegate: AnyObject {
  func loginViewController(_ viewController: LoginViewController, didLogin success: Bool)
}

class LoginViewController: UIViewController {

  weak var delegate: LoginViewControlerDelegate?

  lazy var logInLabel: UILabel = {
    let label = UILabel()
    label.text = "Log In Page"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var logInButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log In", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Log In"
    view.backgroundColor = .white
    view.addSubview(logInLabel)
    view.addSubview(logInButton)

    NSLayoutConstraint.activate([
      logInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logInLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),

      logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
      logInButton.widthAnchor.constraint(equalToConstant: 200),
    ])
  }

  @objc func logInButtonDidTap() {
    delegate?.loginViewController(self, didLogin: true)
  }

}

