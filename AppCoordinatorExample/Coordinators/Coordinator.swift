//
//  Coordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import Foundation

protocol Coordinator: AnyObject {
  var deinitHandler: ((Self) -> Void)? { get set }
}
