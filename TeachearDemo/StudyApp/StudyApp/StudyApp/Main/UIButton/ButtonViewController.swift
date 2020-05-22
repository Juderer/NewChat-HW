//
//  ButtonViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class ButtonViewController: BaseViewController {
    
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 100))
        label.backgroundColor = UIColor.red
        label.text = "这是文本标签"
        self.view.addSubview(label)
        self.label = label
        
        let button = UIButton(frame: CGRect(x: 20, y: 300, width: 100, height: 40))
        button.setTitle("更换背景", for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonAction() {
        if self.label.backgroundColor == UIColor.red {
            self.label.backgroundColor = .blue
        } else {
            self.label.backgroundColor = .red
        }
    }
}
