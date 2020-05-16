//
//  NCNavigationController.swift
//  NewChat
//
//  Created by lou on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

class NCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
    }
    
    /// 初始化
    func setup() {
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor().nc_color2
        navBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor:UIColor().nc_color2]
    }
    
}
