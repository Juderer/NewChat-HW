//
//  PresentViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/24.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class PresentViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeAction))
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
