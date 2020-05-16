//
//  NCContactDetailItemCell.swift
//  NewChat
//
//  Created by luo on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit

public protocol NCContactDetailItemCellDelegate: NSObjectProtocol {
    
    /// 点击编辑
    /// - Parameters:
    ///   - contactDetailItemCell:
    ///   - clickIndex: 
    func contactDetailItemCell(contactDetailItemCell: NCContactDetailItemCell,clickEdit: Int);
}

public class NCContactDetailItemCell: UITableViewCell {
    //
    var title_label: UILabel?
    //
    var value_label: UILabel?
    //
    var edit_btn: UIButton?
    
    var index: Int?
    
    weak var delegate: NCContactDetailItemCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        //
        title_label = UILabel.init(frame: .zero)
        title_label?.font = UIFont.systemFont(ofSize: 17)
        title_label?.textColor = UIColor().nc_color2
        contentView.addSubview(title_label!)
        value_label = UILabel.init(frame: .zero)
        value_label?.font = UIFont.systemFont(ofSize: 15)
        value_label?.textColor = UIColor().nc_color3
        contentView.addSubview(value_label!)

        edit_btn = UIButton(type: .custom)
        edit_btn?.setImage(UIImage(named: "edit"), for: .normal)
        edit_btn?.addTarget(self, action: #selector(self.edit_btnClick), for: .touchUpInside)
        contentView.addSubview(edit_btn!)
        //
        title_label?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(contentView).offset(16)
        })
        value_label?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(title_label!.snp.right).offset(10)
        })
        edit_btn?.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(20)
        })
    }
    
    @objc func edit_btnClick() {
        delegate?.contactDetailItemCell(contactDetailItemCell: self, clickEdit: index!)
    }
    
}


