//
//  NCFeedContentCell.swift
//  NewChat
//
//  Created by lu on 2020/4/27.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit

class NCFeedContentCell: UITableViewCell {

    var conent_label: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         selectionStyle = UITableViewCell.SelectionStyle.none
        //
        conent_label = UILabel.init(frame: .zero)
        conent_label?.font = UIFont.systemFont(ofSize: 17);
        conent_label?.textColor = UIColor().nc_color2
        contentView.addSubview(conent_label!)
        //
        conent_label?.snp.makeConstraints({ (make) in
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
