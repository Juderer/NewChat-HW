//
//  AnimationViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class AnimationViewController: BaseViewController {
    
    var label: UILabel!
    var type: Int = 0
    
    init(type: Int) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 100))
        label.backgroundColor = UIColor.red
        label.text = "这是文本标签"
        self.view.addSubview(label)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if type == 0 {
            setupViewAnimationButton()
        } else if type == 1 {
            setupAnimationButton()
        } else if type == 2 {
            springAnimation()
        } else if type == 3 {
            groupAnimation()
        } else if type == 4 {
            transition()
        }
    }
    
    func springAnimation() {
        let spring = CASpringAnimation(keyPath: "position.x")
        spring.damping = 5
        spring.stiffness = 100
        spring.mass = 1
        spring.initialVelocity = 0
        spring.fromValue = label.layer.position.x
        spring.toValue = label.layer.position.x + 50
        spring.duration = spring.settlingDuration
        label.layer.add(spring, forKey: spring.keyPath)
    }
    
    func groupAnimation() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = 0.5
        animation.fromValue = label.layer.position.y
        animation.toValue = label.layer.position.y + 300
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let spring = CASpringAnimation(keyPath: "position.x")
        spring.damping = 5
        spring.stiffness = 100
        spring.mass = 1
        spring.initialVelocity = 0
        spring.fromValue = label.layer.position.x
        spring.toValue = label.layer.position.x + 50
        spring.duration = spring.settlingDuration
        
        let group = CAAnimationGroup()
        group.animations = [animation, spring]
        label.layer.add(group, forKey: "group")
    }
    
    func transition() {
        let animation = CATransition()
        animation.type = CATransitionType.fade//设置动画的类型
        animation.subtype = CATransitionSubtype.fromRight//设置动画的方向
        animation.duration = 1.0
        label.layer.add(animation, forKey: "pushAnimation")
        label.isHidden = true
    }
}

extension AnimationViewController {
    func setupViewAnimationButton() {
        let button = UIButton(frame: CGRect(x: 20, y: 300, width: 300, height: 40))
        button.setTitle("UIViewAnimation", for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(viewAnimation), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func viewAnimation() {
         UIView.animate(withDuration: 1.3, delay: 0.1, options: [.autoreverse], animations: {
            self.label.transform = self.label.transform.translatedBy(x: 0, y: 100)
            self.label.backgroundColor = UIColor.systemGreen
//            self.label.frame = CGRect(x: 20, y: 500, width: 300, height: 100)
        }) { (finshed) in
            self.label.transform = self.label.transform.translatedBy(x: 0, y: -100)
            self.label.backgroundColor = UIColor.red
        }
    }
}

extension AnimationViewController: CAAnimationDelegate {
    
    func setupAnimationButton() {
        let button = UIButton(frame: CGRect(x: 20, y: 300, width: 300, height: 40))
        button.setTitle("QZAnimation", for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(QZAnimation), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func QZAnimation() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.delegate = self
        animation.duration = 1.3
        animation.fromValue = self.label.frame.origin.y + self.label.frame.size.height/2
        animation.toValue = self.label.frame.origin.y + self.label.frame.size.height/2 + 100
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.label.layer.add(animation, forKey: "position")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        self.label.text = "动画开始"
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.label.text = "动画结束"
    }
}
