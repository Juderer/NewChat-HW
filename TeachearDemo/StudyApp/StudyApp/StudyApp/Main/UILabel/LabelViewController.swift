//
//  LabelViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class LabelViewController: BaseViewController {
    
    var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        normalLabel()
        centerLabel()
        multilLineLabel()
        richLabel()
        addTextField()
    }
    
    func normalLabel() {
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 100))
        label.backgroundColor = UIColor.red
        label.text = "这是文本标签"
        self.view.addSubview(label)
        
        let label1 = label
        
        print("label = \(label), label2 = \(label1)")
    }
    
    func centerLabel() {
        let label = UILabel(frame: CGRect(x: 20, y: 210, width: 300, height: 100))
        label.text = "这是中间对齐文本标签"
        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        self.view.addSubview(label)
    }
    
    func multilLineLabel() {
        let label = UILabel(frame: CGRect(x: 20, y: 320, width: 300, height: 100))
        label.text = "这是多行文本标签\n这是多行文本标签\n这是多行文本标签"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.blue
        self.view.addSubview(label)
    }
    
    func richLabel() {
        let label = UILabel(frame: CGRect(x: 20, y: 320, width: 300, height: 100))
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.blue
        self.view.addSubview(label)
        
        let attributeText = NSMutableAttributedString(string: "富文本\n")
        attributeText.append(NSAttributedString(string: "红色文字\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]))
        attributeText.append(NSAttributedString(string: "黄色文字\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.yellow]))
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "cat1")
        attachment.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        attributeText.append(NSAttributedString(attachment: attachment))
        label.attributedText = attributeText
    }
    
    func addTextField() {
        textField = UITextField(frame: CGRect(x: 20, y: 420, width: 300, height: 30))
        textField.placeholder = "姓名"
        self.view.addSubview(textField)
        
        
        let textField1 = UITextField(frame: CGRect(x: 20, y: 450, width: 300, height: 10))
        textField1.placeholder = "年龄"
        self.view.addSubview(textField1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIApplication.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboardShow(notification: Notification) {
        if textField.isFirstResponder {
            print(textField.placeholder)
        } else {
            print("年龄")
        }
    }
}
