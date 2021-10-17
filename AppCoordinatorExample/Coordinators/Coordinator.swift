//
//  Coordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {
  func coordinatorDidStop(_ coordinator: Coordinator)
}

protocol Coordinator: AnyObject {
  var delegate: CoordinatorDelegate? { get set }
  func start()
}

extension Coordinator {
  func stop() {
    delegate?.coordinatorDidStop(self)
  }
}
