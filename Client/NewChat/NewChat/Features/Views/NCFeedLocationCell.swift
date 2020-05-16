//
//  NCFeedLocationCell.swift
//  NewChat
//
//  Created by liu on 2020/4/27.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

class NCFeedLocationCell: UITableViewCell {

    var location_btn: UIButton?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         selectionStyle = UITableViewCell.SelectionStyle.none
        //
        location_btn = UIButton(type: .custom)
        location_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        location_btn?.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        location_btn?.backgroundColor = UIColor().nc_bgColor
        location_btn?.layer.cornerRadius = 5;
        location_btn?.setTitleColor(UIColor().nc_color3, for: .normal)
        location_btn?.setImage(UIImage(named: "location"), for: .normal)
        contentView.addSubview(location_btn!)
        
        //
        location_btn?.snp.makeConstraints({ (make) in
            make.left.equalTo(65)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.right.lessThanOrEqualToSuperview().offset(-15)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
