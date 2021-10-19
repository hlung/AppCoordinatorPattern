//
//  HomeViewController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

class HomeViewController: UIViewController {

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Welcome!"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var logInButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Log In", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)
    return button
  }()

  lazy var purchaseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Purchase", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGreen
    button.setTitleColor(.black, for: .highlighted)
    button.addTarget(self, action: #selector(purchaseButtonDidTap), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    view.addSubview(logInButton)
    view.addSubview(purchaseButton)

    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),

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

