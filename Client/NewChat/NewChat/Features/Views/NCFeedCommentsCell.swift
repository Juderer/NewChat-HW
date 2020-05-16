//
//  NCFeedCommentsCell.swift
//  NewChat
//
//  Created by liu on 2020/4/27.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

class NCFeedCommentsCell: UITableViewCell {
    
    var wrap: UIStackView?
    var bgView: UIView?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        //
        bgView = UIView()
        bgView?.backgroundColor = UIColor().nc_bgColor
        contentView.addSubview(bgView!)
        wrap = UIStackView()
        wrap?.axis = .vertical
        wrap?.spacing = 5
        contentView.addSubview(wrap!)
        
        //
        bgView?.snp.makeConstraints({ (make) in
            make.left.equalTo(65)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.right.equalTo(-15)
        })
        wrap?.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView!.snp.left).offset(5)
            make.top.equalTo(bgView!.snp.top).offset(5)
            make.bottom.equalTo(bgView!.snp.bottom).offset(-5)
            make.right.equalTo(bgView!.snp.right).offset(-5)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func insertComment(comments: Array<Dictionary<String,Any>>) {
        for (index,view) in (wrap?.subviews.enumerated())! {
            wrap?.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for (index,comment) in comments.enumerated() {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor().nc_color3
            let user = comment["commentBy"] as! Dictionary<String, String>
            let content = comment["content"] as! String
            label.text = "\(user["nickName"] ?? "")：\(content)"
            wrap?.addArrangedSubview(label)
        }
        

    }
}
