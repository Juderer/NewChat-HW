//
//  ScrollViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/24.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class ScrollViewController: BaseViewController {
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: self.view.bounds.height - 100))
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 1000)
        scrollView.showsHorizontalScrollIndicator = true
        self.view.addSubview(scrollView)
        
        let topLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 100))
        topLabel.text = "顶部文本标签"
        scrollView.addSubview(topLabel)
        
        let bottomLabel = UILabel(frame: CGRect(x: 0, y: scrollView.contentSize.height - 100, width: self.view.bounds.width, height: 100))
        bottomLabel.text = "底部文本标签"
        scrollView.addSubview(bottomLabel)
    }
}
