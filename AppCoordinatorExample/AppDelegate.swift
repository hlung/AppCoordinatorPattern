//
//  AppDelegate.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private(set) var coordinator: AppCoordinator!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)

    coordinator = AppCoordinator(window: window)
    coordinator.start()

    window.makeKeyAndVisible()
    self.window = window

    return true
  }

}

