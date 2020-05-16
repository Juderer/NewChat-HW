//
//  NCFeedHeaderCell.swift
//  NewChat
//
//  Created by lu on 2020/4/27.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit

class NCFeedHeaderCell: UITableViewCell {
    
    var header_imageView: UIImageView?
    var name_label: UILabel?
    var creat_label: UILabel?
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        //add subView
        header_imageView = UIImageView.init(frame: .zero)
        contentView.addSubview(header_imageView!)
        
        name_label = UILabel.init(frame: .zero)
        name_label?.font = UIFont.systemFont(ofSize: 15);
        name_label?.textColor = UIColor().nc_color2
        contentView.addSubview(name_label!)
        
        creat_label = UILabel.init(frame: .zero)
        creat_label?.font = UIFont.systemFont(ofSize: 13);
        creat_label?.textColor = UIColor().nc_color3
        contentView.addSubview(creat_label!)
        
        //
        header_imageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-5)
            make.width.height.equalTo(40)
        })
        name_label?.snp.makeConstraints({ (make) in
            make.left.equalTo(header_imageView!.snp.right).offset(10)
            make.top.equalTo(header_imageView!)
        })
        creat_label?.snp.makeConstraints({ (make) in
            make.left.equalTo(header_imageView!.snp.right).offset(10)
            make.bottom.equalTo(header_imageView!)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
