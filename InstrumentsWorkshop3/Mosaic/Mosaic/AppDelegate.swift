//
//  AppDelegate.swift
//  Mosaic
//
//  Created by Donny Wals on 03/07/2018.
//  Copyright © 2018 Donny Wals. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow()
    window?.rootViewController = MosaicViewController()
    window?.makeKeyAndVisible()

    return true
  }
}

