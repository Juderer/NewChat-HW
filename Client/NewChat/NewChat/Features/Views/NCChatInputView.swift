//
//  NCChatInputView.swift
//  NewChat
//
//  Created by liu on 2020/4/26.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

protocol NCChatInputViewDelegate:NSObjectProtocol {
    
    /// 点击发送文本
    /// - Parameters:
    ///   - ChatInputView: <#ChatInputView description#>
    ///   - sendText: <#sendText description#>
    func chatInputView(ChatInputView: NCChatInputView,sendText: String)
}

class NCChatInputView: UIView {
    var textFild: UITextField?
    var send_btn: UIButton?
    
    weak var delegate: NCChatInputViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor().nc_bgColor
        //
        textFild = UITextField(frame: .zero)
        textFild?.delegate = self
        textFild?.returnKeyType = UIReturnKeyType.send
        textFild?.backgroundColor = UIColor.white
        addSubview(textFild!)
        send_btn = UIButton(type: .custom)
        send_btn?.backgroundColor = UIColor().nc_color2
        send_btn?.setTitle("发送", for: .normal)
        send_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        send_btn?.setTitleColor(UIColor.white, for: .normal)
        send_btn?.addTarget(self, action: #selector(self.send_btnClick), for: .touchUpInside)
        addSubview(send_btn!)
        //
        send_btn?.snp.makeConstraints({ (make) in
            make.right.equalTo(-10)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        })
        textFild?.snp.makeConstraints({ (make) in
            make.left.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(30)
            make.right.equalTo(send_btn!.snp.left).offset(-10)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func send_btnClick() {
        delegate?.chatInputView(ChatInputView: self, sendText: textFild?.text ?? "")
        textFild?.text = ""
    }
}

extension NCChatInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send_btnClick()
        return true
    }
}
