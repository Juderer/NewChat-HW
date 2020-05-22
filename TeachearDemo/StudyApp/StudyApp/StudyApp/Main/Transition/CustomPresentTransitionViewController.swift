//
//  CustomPresentTransitionViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/7.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class CustomPresentTransitionViewController: BaseViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        let button = UIButton()
        button.setTitle("关闭", for: .normal)
        button.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CustomPresentTransitionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CustomTransitionAnimator()
        animator.type = .Present
        return CustomTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CustomTransitionAnimator()
        animator.type = .Dismiss
        return CustomTransitionAnimator()
    }
    
}
