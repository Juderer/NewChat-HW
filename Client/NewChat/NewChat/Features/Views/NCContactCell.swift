//
//  NCContactCell.swift
//  NewChat
//
//  Created by luo on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit

class NCContactCell: UITableViewCell {
    
    //
    var header_imageView: UIImageView?
    //
    var name_label: UILabel?
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        //add subView
        header_imageView = UIImageView.init(frame: .zero)
        contentView.addSubview(header_imageView!)
        
        name_label = UILabel.init(frame: .zero)
        name_label?.font = UIFont.systemFont(ofSize: 17);
        name_label?.textColor = UIColor().nc_color2
        contentView.addSubview(name_label!)
        
        //layout
        header_imageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(40)
        })
        name_label?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo((header_imageView?.snp.right)!).offset(10)
        })
        
    }
    
}


