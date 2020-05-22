//
//  BaseViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
}
