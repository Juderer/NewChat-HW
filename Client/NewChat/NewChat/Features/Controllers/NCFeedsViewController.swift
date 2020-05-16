//
//  NCFeedsViewController.swift
//  NewChat
//
//  Created by lu on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

class NCFeedsViewController: UIViewController {
    
    var tableView: UITableView?
    
    var dataSourceArr: Array<Dictionary<String, Any>>?
    
    var feedInputView: NCChatInputView?
    
    var currentCommentIndex:Int?
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
        //
        fetchData()
        //
        addKeyBoardObserver()
        //
        currentCommentIndex = -1
    }
    
    func setup() {
        //
        let sendItem = UIBarButtonItem(title: "分享", style: .plain, target: self, action: #selector(addItemClick))
        navigationItem.rightBarButtonItem = sendItem
        navigationController?.navigationBar.prefersLargeTitles = true
        //
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(NCFeedHeaderCell.self, forCellReuseIdentifier: "NCFeedHeaderCell")
        tableView?.register(NCFeedContentCell.self, forCellReuseIdentifier: "NCFeedContentCell")
        tableView?.register(NCFeedLocationCell.self, forCellReuseIdentifier: "NCFeedLocationCell")
        tableView?.register(NCFeedOperateCell.self, forCellReuseIdentifier: "NCFeedOperateCell")
        tableView?.register(NCFeedCommentsCell.self, forCellReuseIdentifier: "NCFeedCommentsCell")
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 120
        tableView?.separatorStyle = .none
        view.addSubview(tableView!)
        feedInputView = NCChatInputView(frame: .zero)
        feedInputView?.delegate = self
        view.addSubview(feedInputView!)
        //
        feedInputView?.snp.makeConstraints({ (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        })
        //
        let ad = NCFeedAdHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        ad.delegate = self
        tableView?.tableHeaderView = ad
    }
    @objc func addItemClick() {
        let feedSendVC = NCFeedSendViewController()
        feedSendVC.hidesBottomBarWhenPushed = true
        feedSendVC.deleagte = self
        navigationController?.pushViewController(feedSendVC, animated: true)
        
    }
    
    func fetchData() {
        NCNet.fetchFeedsList { (success, data) in
            //
            if !success {
                //数据库查找
                self.dataSourceArr = NCDataBase.shared.queryFeeds(feed: 0, isAll: true)
                self.tableView?.reloadData()
                return;
            }
            //
            if data == nil {
                return
            }
            
            //
            do {
                self.dataSourceArr = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Dictionary<String, Any>] ?? [])
                self.tableView?.reloadData()
                //插入数据库
                NCDataBase.shared.insertFeeds(feeds: self.dataSourceArr!)
            } catch {
                print("JSONSerialization error:", error)
            }
        }
    }
    
    func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (noti) in
            if let info = noti.userInfo {
                let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                
                self.feedInputView?.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-frame.height+self.view.safeAreaInsets.bottom-50)
                })
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (noti) in
            if let info = noti.userInfo {
                _ = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                
                self.feedInputView?.snp.updateConstraints({ (make) in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                })
            }
        }
    }
}

extension NCFeedsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = self.dataSourceArr?.count {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = self.dataSourceArr![indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NCFeedHeaderCell") as! NCFeedHeaderCell
            let user = feed["creatBy"] as! Dictionary<String,String>
            cell.name_label?.text = user["nickName"]
            cell.creat_label?.text = feed["creatAt"] as? String
            if let header = UIImage(named:user["id"] ?? "") {
                cell.header_imageView?.image = header
            }else {
                cell.header_imageView?.image = UIImage(named: "user")
            }
            return cell
            
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NCFeedContentCell") as! NCFeedContentCell
            cell.conent_label?.text = feed["content"] as? String
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NCFeedLocationCell") as! NCFeedLocationCell
            let location = feed["location"] as? String
            cell.location_btn?.setTitle(location, for: .normal)
            return cell
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NCFeedOperateCell") as! NCFeedOperateCell
            cell.delegate = self
            let favors = feed["favortes"] as! [Dictionary<String,String>]
            cell.favor_btn?.setTitle("\(favors.count)", for: .normal)
            var favored = false
            for (index,user) in favors.enumerated() {
                if user["id"] == NCLoginUser.shared.userId {
                    favored = true
                    break
                }
            }
            cell.favor_btn?.isSelected = favored
            cell.index = indexPath.section
            return cell
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NCFeedCommentsCell") as! NCFeedCommentsCell
            let comments = feed["comments"]as!Array<Dictionary<String,Any>>
            cell.insertComment(comments: comments)
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let feed = self.dataSourceArr![indexPath.section]
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }else if indexPath.row == 1 {
            return UITableView.automaticDimension
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NCFeedLocationCell") as! NCFeedLocationCell
            let location = feed["location"] as? String
            if location == "" {
                cell.location_btn?.isHidden = true
                return 0
            }
            cell.location_btn?.isHidden = false
            return UITableView.automaticDimension
        }else if indexPath.row == 3 {
            return UITableView.automaticDimension
        }else if indexPath.row == 4 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "NCFeedCommentsCell") as! NCFeedCommentsCell
            let comments = feed["comments"]as!Array<Dictionary<String,Any>>
            if comments.count == 0 {
                cell.bgView?.isHidden = true
                return 0
            }
            cell.bgView?.isHidden = false
            return UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
}

extension NCFeedsViewController:NCFeedOperateCellDelegate {
    
    func feedOprateCell(feedOprateCell: NCFeedOperateCell, clickFavorAtIndex: Int) {
        currentCommentIndex = clickFavorAtIndex
        guard currentCommentIndex!>=0 && currentCommentIndex!<dataSourceArr!.count else {
            return
        }
        let feed = self.dataSourceArr![currentCommentIndex!]
        let favors = feed["favortes"] as! [Dictionary<String,String>]
        var shouldFavor = 1
        
        for (index,user) in favors.enumerated() {
            if user["id"] == NCLoginUser.shared.userId {
                shouldFavor = 0
                break
            }
        }
        NCNet.feedFavor(params: ["feed":feed["id"] as! Int ,"favor":shouldFavor,"userId":NCLoginUser.shared.userId]) { (success, data) in
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
                let feed = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any> ?? [:])
                self.fetchData()
            } catch {
                print("JSONSerialization error:", error)
            }
        }
    }
    
    func feedOprateCell(feedOprateCell: NCFeedOperateCell, clickCommentAtIndex: Int) {
        feedInputView?.textFild?.becomeFirstResponder()
        currentCommentIndex = clickCommentAtIndex
        
        
    }
}

extension NCFeedsViewController: NCChatInputViewDelegate {
    func chatInputView(ChatInputView: NCChatInputView, sendText: String) {
        guard sendText != "" else {
            return
        }
        guard currentCommentIndex!>=0 && currentCommentIndex!<dataSourceArr!.count else {
            return
        }
        let feed = self.dataSourceArr![currentCommentIndex!]
        NCNet.feedComment(params: ["feed":feed["id"] as! Int,"userId":NCLoginUser.shared.userId ,"content":sendText]) { (success, data) in
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
                let comment = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any> ?? [:])
                self.fetchData()
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        feedInputView?.textFild?.resignFirstResponder()
        currentCommentIndex = -1
    }
}

extension NCFeedsViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        feedInputView?.textFild?.resignFirstResponder()
        currentCommentIndex = -1
    }
}

extension NCFeedsViewController : NCFeedSendViewControllerDelegate {
    func feedSendViewController(feedSendViewController: NCFeedSendViewController, sendFinish: Dictionary<String, Any>) {
        fetchData()
    }
    
}

extension NCFeedsViewController: NCFeedAdHeaderViewDelegate {
    func feedAdHeaderView(feedAdHeaderViewClickClose: NCFeedAdHeaderView) {
        tableView?.tableHeaderView = nil
    }
}
