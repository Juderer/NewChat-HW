//
//  TransitionAnimator.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/7.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

enum TransitionType {
    case Present
    case Dismiss
    case Push
    case Pop
}

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var type: TransitionType = .Present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        guard let topView = toViewController?.view else {
            return
        }
        guard let fromView = fromViewController?.view else {
            return
        }
        if type == .Present || type == .Dismiss {
            containerView.insertSubview(topView, aboveSubview: fromView)
        } else {
            containerView.addSubview(topView)
            containerView.addSubview(fromView)
        }
        
        var destTransform: CGAffineTransform!
        switch type {
        case .Present, .Push:
            topView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            destTransform = CGAffineTransform.identity
        case .Dismiss, .Pop:
            topView.transform = CGAffineTransform.identity
            destTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            topView.transform = destTransform
        }, completion: ({completed in
            transitionContext.completeTransition(true)
        }))
    }
}
