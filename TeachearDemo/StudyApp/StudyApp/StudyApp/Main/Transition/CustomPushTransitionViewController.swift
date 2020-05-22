//
//  CustomPushTransitionViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/7.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class CustomPushTransitionViewController: BaseViewController {
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.navigationController?.delegate = self
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .red
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.delegate = nil
    }
}

extension CustomPushTransitionViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CustomTransitionAnimator()
        if operation == .push {
            animator.type = .Push
        } else if operation == .pop {
            animator.type = .Pop
        }
        return CustomTransitionAnimator()
    }

}
