//
//  NCFeedOperateCell.swift
//  NewChat
//
//  Created by lou on 2020/4/27.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

protocol NCFeedOperateCellDelegate: NSObjectProtocol {
    
    func feedOprateCell(feedOprateCell: NCFeedOperateCell,clickFavorAtIndex: Int);
    func feedOprateCell(feedOprateCell: NCFeedOperateCell,clickCommentAtIndex: Int);
    
}

class NCFeedOperateCell: UITableViewCell {
    
    var favor_btn: UIButton?
    var comment_btn: UIButton?
    var wrap: UIStackView?
    weak var delegate:NCFeedOperateCellDelegate?
    var index: Int?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         selectionStyle = UITableViewCell.SelectionStyle.none
        //
        favor_btn = UIButton(type: .custom)
        favor_btn?.setImage(UIImage(named: "favorite"), for: .normal)
        favor_btn?.setImage(UIImage(named: "favoriteSelect"), for: .selected)
        favor_btn?.addTarget(self, action: #selector(favor_btnClick), for: .touchUpInside)
        favor_btn?.setTitleColor(UIColor().nc_color2, for: .selected)
        favor_btn?.setTitleColor(UIColor().nc_color3, for: .normal)
        favor_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        favor_btn?.setTitle("0", for:.normal)
        contentView.addSubview(favor_btn!)
        comment_btn = UIButton(type: .custom)
        comment_btn?.setImage(UIImage(named: "comment"), for: .normal)
        comment_btn?.addTarget(self, action: #selector(comment_btnClick), for: .touchUpInside)
        contentView.addSubview(comment_btn!)
        wrap = UIStackView()
        wrap?.distribution = .fillEqually
        contentView.addSubview(wrap!)
        
        //
        wrap?.snp.makeConstraints({ (make) in
            make.left.equalTo(65)
            make.top.equalTo(5)
            make.height.equalTo(20)
            make.bottom.equalTo(-5)
            make.right.equalTo(-15)
        })
        wrap?.addArrangedSubview(favor_btn!)
        wrap?.addArrangedSubview(comment_btn!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func favor_btnClick() {
        delegate?.feedOprateCell(feedOprateCell: self, clickFavorAtIndex: index!)
    }
    
    @objc func comment_btnClick() {
        delegate?.feedOprateCell(feedOprateCell: self, clickCommentAtIndex: index!)
    }

}
