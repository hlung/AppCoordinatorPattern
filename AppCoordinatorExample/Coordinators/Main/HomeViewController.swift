//
//  HomeViewController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

class HomeViewController: UIViewController {

  lazy var logInButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log In", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)
    return button
  }()

  lazy var purchaseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Purchase", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(purchaseButtonDidTap), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Home"
    view.backgroundColor = .white
    view.addSubview(logInButton)
    view.addSubview(purchaseButton)

    NSLayoutConstraint.activate([
      logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      logInButton.widthAnchor.constraint(equalToConstant: 200),

      purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      purchaseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
      purchaseButton.widthAnchor.constraint(equalToConstant: 200),
    ])
  }

  @objc func logInButtonDidTap() {
    UIApplication.shared.coordinator.showLoginFlow()
  }

  @objc func purchaseButtonDidTap() {
    UIApplication.shared.coordinator.showPurchaseFlow()
  }

}

