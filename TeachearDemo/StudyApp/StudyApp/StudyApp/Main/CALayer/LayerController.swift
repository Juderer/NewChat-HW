//
//  LayerController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class LayerController: BaseViewController {
    var layer: CALayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layer = CALayer()
        layer.backgroundColor = UIColor.red.cgColor
        layer.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        self.view.layer.addSublayer(layer)
        
        let button = UIButton(frame: CGRect(x: 20, y: 300, width: 300, height: 40))
        button.setTitle("changeAnchorPoint", for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(changeAnchorPoint), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func changeAnchorPoint() {
        if abs(layer.anchorPoint.x - 0.5) <= 0.01 {
            layer.anchorPoint = CGPoint(x: 0, y: 0)
        } else {
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
}
