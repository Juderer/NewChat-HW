//
//  ImageViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class ImageViewController: BaseViewController {
    
    var imageView: UIImageView!
    
    var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        imageView.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        imageView.image = UIImage(named: "cat1")
        imageView.backgroundColor = .red
//        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        segment = UISegmentedControl(items: ["scaleToFill", "scaleAspectFit", "scaleAspectFill"])
        segment.frame = CGRect(x: 20, y: 230, width: 300, height: 40)
        self.view.addSubview(segment)
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc func segmentChanged() {
        if let mode = UIView.ContentMode(rawValue: segment.selectedSegmentIndex) {
            imageView.contentMode = mode
        }
    }
}
