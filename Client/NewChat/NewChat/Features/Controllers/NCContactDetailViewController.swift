//
//  NCContactDetailViewController.swift
//  NewChat
//
//  Created by luo on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit

protocol NCContactDetailViewControllerDelegate: NSObjectProtocol {
    
    /// 更新用户信息
    /// - Parameters:
    ///   - contactDetailViewController:
    ///   - updateUser:
    func contactDetailViewController(contactDetailViewController: NCContactDetailViewController,updateUser: Dictionary<String, String>);
}

public class NCContactDetailViewController: UIViewController{
    
    /// <#Description#>
    var user: Dictionary<String, String>?
    
    var header_imageView: UIImageView?
    
    var tableView: UITableView?
    
    var send_btn: UIButton?
    
    weak var delegate: NCContactDetailViewControllerDelegate?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
        //
        
    }
    
    private func setup() {
        view.backgroundColor = UIColor().nc_bgColor
        navigationItem.largeTitleDisplayMode = .never;
        //
        header_imageView = UIImageView.init(frame: .zero)
        view.addSubview(header_imageView!)
        if let header = UIImage(named:user!["id"] ?? "") {
            header_imageView?.image = header
        }else {
            header_imageView?.image = UIImage(named: "user")
        }
        
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView?.dataSource = self as! UITableViewDataSource
        tableView?.register(NCContactDetailItemCell.self, forCellReuseIdentifier: "NCContactDetailItemCell")
        tableView?.rowHeight = 30
        view.addSubview(tableView!)
        send_btn = UIButton(type: .custom)
        send_btn?.setTitle("发消息", for: .normal)
        send_btn?.setTitleColor(UIColor.white, for: .normal)
        send_btn?.backgroundColor = UIColor().nc_color2
        send_btn?.addTarget(self, action: #selector(self.send_btnClick), for: .touchUpInside)
        view.addSubview(send_btn!)
        
        //
        header_imageView?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.height.equalTo(60)
        })
        
        tableView?.snp.makeConstraints({ (make) in
            make.top.equalTo(header_imageView!.snp.bottom).offset(30);
            make.left.right.equalTo(view)
            make.height.equalTo(4*30)
        })
        send_btn?.snp.makeConstraints({ (make) in
            make.top.equalTo(tableView!.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
        })
    }
    
    @objc private func send_btnClick(){
        let chatDetail = NCChatDetailViewController()
        chatDetail.chatUserId = user!["id"]
        navigationController?.pushViewController(chatDetail, animated: true)
        
    }

}

extension NCContactDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NCContactDetailItemCell")as!NCContactDetailItemCell
        if indexPath.row == 0 {
            cell.title_label?.text = "昵称"
            cell.value_label?.text = user!["nickName"]
        }else if indexPath.row == 1 {
            cell.title_label?.text = "性别"
            cell.value_label?.text = user!["sex"]
        }else if indexPath.row == 2 {
            cell.title_label?.text = "地区"
            cell.value_label?.text = user!["adress"]
        }else if indexPath.row == 3 {
            cell.title_label?.text = "邮箱"
            cell.value_label?.text = user!["email"]
        }
        cell.edit_btn?.isHidden = !(NCLoginUser.shared.userId == user!["id"])
        send_btn?.isHidden = (NCLoginUser.shared.userId == user!["id"])
        cell.delegate = self as NCContactDetailItemCellDelegate
        cell.index = indexPath.row
        return cell
        
    }
    
    
}

extension NCContactDetailViewController: NCContactDetailItemCellDelegate {
    public func contactDetailItemCell(contactDetailItemCell: NCContactDetailItemCell, clickEdit: Int) {
        var title = ""
        if clickEdit == 0 {
            title = "修改昵称"
        }else if clickEdit == 1 {
            title = "修改性别"
        }else if clickEdit == 2 {
            title = "修改地区"
        }else if clickEdit == 3 {
            title = "修改邮箱"
        }
        let alter = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alter.addTextField { (textField) in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            if let modifyText = alter.textFields?.first?.text {
                var modifyUser = self.user
                if clickEdit == 0 {
                    modifyUser?["nickName"] = modifyText
                }else if clickEdit == 1 {
                    modifyUser?["nickName"] = modifyText
                }else if clickEdit == 2 {
                    modifyUser?["nickName"] = modifyText
                }else if clickEdit == 3 {
                    modifyUser?["nickName"] = modifyText
                }
                NCNet.modifyUserInfo(user: modifyUser!) { (success, data) in
                    //
                    if !success {
                        return
                    }
                    //
                    if data == nil {
                        return
                    }
                    //
                    do {
                        self.user = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, String>)
                        self.tableView?.reloadData()
                        self.delegate?.contactDetailViewController(contactDetailViewController: self, updateUser: self.user!)
                        
                    } catch {
                        print("JSONSerialization error:", error)
                    }
                }
            }
        }
        alter.addAction(cancelAction)
        alter.addAction(sureAction)
        navigationController?.present(alter, animated: true, completion: nil)
    }
}
