//
//  LoginViewController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

protocol LoginViewControlerDelegate: AnyObject {
  func loginViewControllerDidFinish(_ viewController: LoginViewController)
}

class LoginViewController: UIViewController {

  weak var delegate: LoginViewControlerDelegate?

  lazy var logInLabel: UILabel = {
    let label = UILabel()
    label.text = "Log In Page"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Log In"
    view.backgroundColor = .white
    view.addSubview(logInLabel)

    NSLayoutConstraint.activate([
      logInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logInLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
    ])
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    delegate?.loginViewControllerDidFinish(self)
  }

}

