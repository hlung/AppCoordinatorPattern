//
//  ChildCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import Foundation

protocol ChildCoordinator: AnyObject {
//  var completion: ((Self) -> Void)? { get set }
  var delegate: ChildCoordinatorDelegate? { get set }
  func start()
  func stop()
}

extension ChildCoordinator {
  func stop() {
    delegate?.childCoordinatorDidStop(self)
  }
}

//protocol ChildCoordinator: AnyObject {
//  var delegate: CoordinatorDelegate? { get set }
//  func start()
//}

protocol ChildCoordinatorDelegate: AnyObject {
  func childCoordinatorDidStop(_ coordinator: ChildCoordinator)
}
