//
//  NCLoginUser.swift
//  NewChat
//
//  Created by zhu on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import LeanCloud

class NCLoginUser{
    
    /// 生成当前用户为单例
    // iPhone 11 Pro
    static var shared = NCLoginUser(userId: "caiwen")
    // iPhone 11
//    static var shared = NCLoginUser(userId: "geqiang")
//    static var shared = NCLoginUser(userId: "ahua")
//    static var shared = NCLoginUser(userId: "huangrong")
//    static var shared = NCLoginUser(userId: "bihui")
    
    /// userId
    let userId: String
    
    var imuser: IMClient?
    
    init(userId: String) {
        self.userId = userId;
        do {
            self.imuser = try IMClient(ID: userId)
        } catch {
            print(error)
        }
    }
    
    public func loginIM() {
        imuser!.open { (result) in
            switch result {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "NCIMLoginSuccess"), object: nil)
                break
            case .failure(error: let error):
                print(error)
            }
        }
    }
    
}
