//
//  NCTabBarController.swift
//  NewChat
//
//  Created by liu on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

class NCTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
        NCLoginUser.shared.loginIM()
    }
    /// 初始化
    func setup(){
        //配置之item的选中
        tabBar.tintColor = UIColor().nc_color2
        tabBar.unselectedItemTintColor = UIColor().nc_color1
        
        //
        let tabbarItem = UITabBarItem.appearance()
        let normalTitleAtt = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor:UIColor().nc_color1]
        let selectedTitleAtt = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor:UIColor().nc_color2]
        tabbarItem.setTitleTextAttributes(normalTitleAtt, for: .normal)
        tabbarItem.setTitleTextAttributes(selectedTitleAtt, for: .selected)
    }
}
