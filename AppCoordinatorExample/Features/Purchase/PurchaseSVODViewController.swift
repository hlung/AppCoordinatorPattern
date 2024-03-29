import UIKit

protocol PurchaseSVODViewControllerDelegate: AnyObject {
  func purchaseSVODViewControllerDidPurchase(_ viewController: PurchaseSVODViewController)
  func purchaseSVODViewControllerDidCancel(_ viewController: PurchaseSVODViewController)
  func purchaseSVODViewControllerDidDeinit(_ viewController: PurchaseSVODViewController)
}

class PurchaseSVODViewController: UIViewController {

  weak var delegate: PurchaseSVODViewControllerDelegate?

  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    return stackView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Purchase SVOD"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var buyButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Buy", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGreen
    button.setTitleColor(.black, for: .highlighted)
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    return button
  }()

  lazy var cancelButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Cancel", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemGray
    button.setTitleColor(.black, for: .highlighted)
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    return button
  }()

  deinit {
    // User may dismiss by just swiping down the modal, which won't trigger any button selector.
    // So we need to catch it here, so that the delegate (coordinator) is aware of the dismiss and
    // can remove the child properly.
    delegate?.purchaseSVODViewControllerDidDeinit(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(type(of: self))"
    view.backgroundColor = .white
    view.addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(buyButton)
    stackView.addArrangedSubview(cancelButton)
    stackView.addArrangedSubview(UIView())

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])

    buyButton.addTarget(self, action: #selector(buyButtonDidTap), for: .touchUpInside)
    cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
  }

  @objc func buyButtonDidTap() {
    present(purchaseConfirmationAlertController(), animated: true)
  }

  @objc func cancelButtonDidTap() {
    self.delegate?.purchaseSVODViewControllerDidCancel(self)
  }

  // MARK: - Alert Controllers

  func purchaseConfirmationAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase confirmation", message: "Do you want to purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.present(self.purchaseSuccessAlertController(), animated: true)
    }))
    return alert
  }

  func purchaseSuccessAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase success", message: "All set!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.delegate?.purchaseSVODViewControllerDidPurchase(self)
    }))
    return alert
  }
  
}

