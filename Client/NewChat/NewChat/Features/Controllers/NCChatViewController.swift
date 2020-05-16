//
//  NCChatViewController.swift
//  NewChat
//
//  Created by lou on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import LeanCloud

class NCChatViewController: UIViewController {
    
    //
    var tableView: UITableView?
    
    //
    var conversations:Array<IMConversation>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
        //
        addLoginSuccessObserver()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
        fetchConversationList()
    }
    
    func setup() {
        var header = UIImage(named: "user")
        if let img = UIImage(named: NCLoginUser.shared.userId) {
            header = img
        }
        let headerItem = UIButton(type: .custom)
        headerItem.setImage(header, for: .normal)
        headerItem.addTarget(self, action: #selector(self.headerItemClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: headerItem)
        headerItem.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(NCChatConversationCell.self, forCellReuseIdentifier: "NCChatConversationCell")
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 60
        tableView?.tableFooterView = UIView()
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        view.addSubview(tableView!)
        
    }
    
    @objc func headerItemClick(){

        NCNet.fetchSomeUser(userId: NCLoginUser.shared.userId) { (success, data) in
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
                
                let user = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, String> ?? [:])
                let contact = NCContactDetailViewController()
                contact.hidesBottomBarWhenPushed = true
//                contact.delegate = self as! NCContactDetailViewControllerDelegate
                contact.user = user
                self.navigationController?.pushViewController(contact, animated: true)
                
            } catch {
                print("JSONSerialization error:", error)
            }
        }
    }
    
    func fetchConversationList() {
        do {
            try NCLoginUser.shared.imuser!.conversationQuery.findConversations { (result) in
                switch result {
                case .success(value: let conversations):
                    self.conversations = conversations
                    self.tableView?.reloadData()
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            
        }
    }
    func addLoginSuccessObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NCIMLoginSuccess"), object: nil, queue: .main) { (noti) in
            self.fetchConversationList()
        }
    }
}

extension NCChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = conversations {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NCChatConversationCell")as!NCChatConversationCell
        let conversation = conversations?[indexPath.row]
        cell.name_label?.text = conversation?.name
        if let header = UIImage(named:conversation?.name ?? "") {
            cell.header_imageView?.image = header
        }else {
            cell.header_imageView?.image = UIImage(named: "user")
        }
        
        let lastMsg = conversation?.lastMessage as? IMTextMessage
        if let m = lastMsg {
           cell.lastMsg_label?.text = m.text
        }
        return cell
    }
    
    
}

extension NCChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let conversation = conversations?[indexPath.row]
        var chatUser: String?
        if let members = conversation?.members {
            for index in 0..<members.count {
                if members[index] != NCLoginUser.shared.userId {
                    chatUser = members[index]
                    break
                }
            }
        }
        let chatDetail = NCChatDetailViewController()
        chatDetail.chatUserId = chatUser
        chatDetail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatDetail, animated: true)
        
    }
}
