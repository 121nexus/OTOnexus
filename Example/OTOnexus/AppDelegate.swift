//
//  AppDelegate.swift
//  OTOnexus
//
//  Created by Nic Schlueter on 09/08/2017.
//  Copyright (c) 2017 121nexus. All rights reserved.
//

import UIKit
import OTOnexus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let uploadModule = OTOImageUploadModule()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        OTOnexus.configure(withApiKey: ApiConfiguration.apiKey)
        return true
    }
}

