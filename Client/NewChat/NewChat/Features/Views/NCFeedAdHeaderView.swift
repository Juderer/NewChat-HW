//
//  NCFeedAdHeaderView.swift
//  NewChat
//
//  Created by lu on 2020/5/2.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit

protocol NCFeedAdHeaderViewDelegate: NSObjectProtocol {
    func feedAdHeaderView(feedAdHeaderViewClickClose: NCFeedAdHeaderView);
}

class NCFeedAdHeaderView: UIView {
    
    var ad_imageView: UIImageView?
    var close_btn: UIButton?
    weak var delegate: NCFeedAdHeaderViewDelegate?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor().nc_bgColor
        //
        ad_imageView = UIImageView()
        ad_imageView?.image = UIImage(named: "ad")
        addSubview(ad_imageView!)
        
        close_btn = UIButton(type: .custom)
        close_btn?.addTarget(self, action: #selector(close_btnClick), for: .touchUpInside)
        close_btn?.setImage(UIImage(named: "close"), for: .normal)
        addSubview(close_btn!)
        
        //
        ad_imageView?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalToSuperview()
        })
        close_btn?.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.width.height.equalTo(20)
        })
       

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close_btnClick() {
        delegate?.feedAdHeaderView(feedAdHeaderViewClickClose: self)
    }

}
