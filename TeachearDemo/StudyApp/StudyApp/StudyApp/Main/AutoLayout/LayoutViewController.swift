//
//  LayoutViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class LayoutViewController: BaseViewController {
    enum Layout {
        case Frame
        case AutoLayout
        case VFL
        case StackViews
        case SnapKit
    }
    private var layoutType: Layout = .Frame
    private var stackView: UIStackView!
    
    init(layoutType: Layout = .AutoLayout) {
        super.init(nibName: nil, bundle: nil)
        self.layoutType = layoutType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch layoutType {
        case .Frame:
            frameLayout()
        case .AutoLayout:
            systemAutoLayout()
        case .SnapKit:
            snapKitLayout()
        case .VFL:
            VFL()
        case .StackViews:
            stackViews()
        }
    }
    
    func frameLayout() {
        let blueView = UIView()
        var safeArea: UIEdgeInsets!
        if #available(iOS 11.0, *) {
            safeArea = self.view.safeAreaInsets
        } else {
            safeArea = UIEdgeInsets.zero
        }
        blueView.frame = CGRect(x: safeArea.left + 20, y: safeArea.top + 100, width: 100, height: self.view.frame.height - safeArea.top - safeArea.bottom)
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)

        let orangView = UIView()
        orangView.backgroundColor = UIColor.orange
        blueView.addSubview(orangView)
        orangView.frame = blueView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func systemAutoLayout() {
        let blueView = UIView()
        blueView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)

        let orangView = UIView()
        orangView.backgroundColor = UIColor.orange
        blueView.addSubview(orangView)
        orangView.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: orangView, attribute: .left, relatedBy: .equal, toItem: blueView, attribute: .left, multiplier: 1, constant: 10)
        let right = NSLayoutConstraint(item: orangView, attribute: .right, relatedBy: .equal, toItem: blueView, attribute: .right, multiplier: 1, constant: -10)
        let top = NSLayoutConstraint(item: orangView, attribute: .top, relatedBy: .equal, toItem: blueView, attribute: .top, multiplier: 1, constant: 10)
        let bottom = NSLayoutConstraint(item: orangView, attribute: .bottom, relatedBy: .equal, toItem: blueView, attribute: .bottom, multiplier: 1, constant: -10)
//        blueView.addConstraints([left, right, top, bottom])
        NSLayoutConstraint.activate([left, right, top, bottom])
    }
    
    func VFL() {
        let blueView = UIView()
        blueView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)

        let orangView = UIView()
        orangView.backgroundColor = UIColor.orange
        blueView.addSubview(orangView)
        orangView.translatesAutoresizingMaskIntoConstraints = false
        let HVFL = "H:|-margin-[orangView(50)]"
        let VVFL = "V:|-margin-[orangView]-margin-|"
        let metrics = ["margin": 20]
        let bindings = ["orangView": orangView]
        let Hconstraints = NSLayoutConstraint.constraints(withVisualFormat: HVFL, options: [.alignAllCenterX, .alignAllCenterY], metrics: metrics, views: bindings)
        let Vconstraints = NSLayoutConstraint.constraints(withVisualFormat: VVFL, options: [.alignAllCenterX, .alignAllCenterY], metrics: metrics, views: bindings)
        blueView.addConstraints(Hconstraints)
        blueView.addConstraints(Vconstraints)
    }
    
    func snapKitLayout() {
        let blueView = UIView()
        blueView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)

        let orangView = UIView()
        orangView.backgroundColor = UIColor.orange
        blueView.addSubview(orangView)
        orangView.snp.makeConstraints { (make) in
            make.edges.equalTo(blueView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    func stackViews() {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        
        let label1 = UILabel()
        label1.text = "label1"
        stackView.addArrangedSubview(label1)
        
        let label2 = UILabel()
        label2.text = "label2"
        stackView.addArrangedSubview(label2)
        
        self.view.addSubview(stackView)
        stackView.frame = self.view.bounds
        self.stackView = stackView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let tmpView = self.stackView {
            tmpView.frame = self.view.bounds
        }
    }
}
