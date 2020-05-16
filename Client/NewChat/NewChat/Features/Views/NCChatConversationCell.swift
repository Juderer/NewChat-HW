//
//  NCChatConversationCell.swift
//  NewChat
//
//  Created by liu on 2020/4/26.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

class NCChatConversationCell: UITableViewCell {
    
    var header_imageView: UIImageView?
    var name_label: UILabel?
    var lastMsg_label: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        //
        header_imageView = UIImageView.init(frame: .zero)
        contentView.addSubview(header_imageView!)
        name_label = UILabel.init(frame: .zero)
        name_label?.textColor = UIColor().nc_color2
        name_label?.font = UIFont.systemFont(ofSize: 17);
        contentView.addSubview(name_label!)
        lastMsg_label = UILabel.init(frame: .zero)
        lastMsg_label?.textColor = UIColor().nc_color3
        lastMsg_label?.font = UIFont.systemFont(ofSize: 15);
        contentView.addSubview(lastMsg_label!)
        
        //layout
        header_imageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(40)
        })
        name_label?.snp.makeConstraints({ (make) in
            make.top.equalTo(header_imageView!.snp.top)
            make.left.equalTo((header_imageView?.snp.right)!).offset(10)
        })
        lastMsg_label?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(header_imageView!.snp.bottom)
            make.left.equalTo((header_imageView?.snp.right)!).offset(10)
        })
    }
    
}
