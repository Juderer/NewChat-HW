//
//  NCChatItemCell.swift
//  NewChat
//
//  Created by liu on 2020/4/26.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit
import LeanCloud

class NCChatItemCell: UITableViewCell {
    
    var leftHeader_imageView: UIImageView?
    var leftName_label: UILabel?
    var leftConent_label: UILabel?
    
    var rightHeader_imageView: UIImageView?
    var rightName_label: UILabel?
    var rightConent_label: UILabel?
    
    var message: IMTextMessage?
    
    
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
        leftHeader_imageView = UIImageView.init(frame: .zero)
        contentView.addSubview(leftHeader_imageView!)
        rightHeader_imageView = UIImageView.init(frame: .zero)
        contentView.addSubview(rightHeader_imageView!)
        leftName_label = UILabel.init(frame: .zero)
        leftName_label?.font = UIFont.systemFont(ofSize: 17);
        leftName_label?.textColor = UIColor().nc_color2
        contentView.addSubview(leftName_label!)
        rightName_label = UILabel.init(frame: .zero)
        rightName_label?.font = UIFont.systemFont(ofSize: 17);
        rightName_label?.textColor = UIColor().nc_color2
        contentView.addSubview(rightName_label!)
        leftConent_label = UILabel.init(frame: .zero)
        leftConent_label?.textColor = UIColor().nc_color3
        leftConent_label?.font = UIFont.systemFont(ofSize: 15);
        contentView.addSubview(leftConent_label!)
        rightConent_label = UILabel.init(frame: .zero)
        rightConent_label?.font = UIFont.systemFont(ofSize: 15);
        rightConent_label?.textColor = UIColor().nc_color3
        rightConent_label?.textAlignment = .right
        contentView.addSubview(rightConent_label!)
        
        //
        leftHeader_imageView?.snp.makeConstraints({ (make) in
            make.top.left.equalTo(15);
            make.bottom.equalTo(-15)
            make.height.width.equalTo(40)
        })
        rightHeader_imageView?.snp.makeConstraints({ (make) in
            make.top.equalTo(15);
            make.bottom.right.equalTo(-15)
            make.height.width.equalTo(40)
        })
        leftName_label?.snp.makeConstraints({ (make) in
            make.left.equalTo(leftHeader_imageView!.snp.right).offset(10)
            make.top.equalTo(leftHeader_imageView!)
        })
        rightName_label?.snp.makeConstraints({ (make) in
            make.right.equalTo(rightHeader_imageView!.snp.left).offset(-10)
            make.top.equalTo(rightHeader_imageView!)
        })
        leftConent_label?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(leftHeader_imageView!)
            make.left.equalTo(leftHeader_imageView!.snp.right).offset(10)
            make.right.lessThanOrEqualTo(contentView).offset(-30)
        })
        rightConent_label?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(rightHeader_imageView!)
            make.right.equalTo(rightHeader_imageView!.snp.left).offset(-10)
            make.left.lessThanOrEqualTo(contentView).offset(30)
        })
    }
    
    func deliverMessage(msg: IMMessage) {
        message = (msg as! IMTextMessage)
        if self.message?.ioType == IMMessage.IOType.in {
            leftHeader_imageView?.isHidden = false
            leftConent_label?.isHidden = false
            leftName_label?.isHidden = false;
            rightHeader_imageView?.isHidden = true
            rightConent_label?.isHidden = true
            rightName_label?.isHidden = true;
            leftName_label?.text = message?.fromClientID
            leftConent_label?.text = message?.text
            if var header = UIImage(named:message?.fromClientID ?? "") {
                leftHeader_imageView!.image = header
            }else {
                leftHeader_imageView!.image = UIImage(named: "user")
            }
        }else if self.message?.ioType == IMMessage.IOType.out {
            leftHeader_imageView?.isHidden = true
            leftConent_label?.isHidden = true
            leftName_label?.isHidden = true;
            rightHeader_imageView?.isHidden = false
            rightConent_label?.isHidden = false
            rightName_label?.isHidden = false;
            rightName_label?.text = message?.currentClientID
            rightConent_label?.text = message?.text
            if var header = UIImage(named:message?.currentClientID ?? "") {
                rightHeader_imageView!.image = header
            }else {
                rightHeader_imageView!.image = UIImage(named: "user")
            }
        }
        
    }
}
