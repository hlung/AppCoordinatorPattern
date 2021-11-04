//
//  ChildCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import Foundation

protocol ChildCoordinator: AnyObject {
  var teardown: ((Self) -> Void)? { get set }

  func start()
}

extension ChildCoordinator {
  func stop() {
    teardown?(self)
  }
}
