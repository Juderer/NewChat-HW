//
//  AppDelegate.swift
//  NewChat
//
//  Created by zhu on 2020/4/19.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //配置learnCloud
        do {
            try LCApplication.default.set(id: "6LrU1JJWBDnnschkW4wjKKG1-gzGzoHsz", key: "8T9Gl6OIKDoVFGOOtHwudwqO", serverURL: "https://6lru1jjw.lc-cn-n1-shared.com", configuration: LCApplication.Configuration.default)
        } catch {
            
        }
        //login IM
//        NCLoginUser.shared.loginIM()
//        do {
//            NCLoginUser.shared.imuser!.open { (result) in
//                switch result {
//                case .success:
//                    break
//                case .failure(error: let error):
//                    print(error)
//                }
//            }
//        } catch {
//            print(error)
//        }
        return true
    }
 
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

