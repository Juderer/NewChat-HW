//
//  NCChatDetailViewController.swift
//  NewChat
//
//  Created by liu on 2020/4/26.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import LeanCloud
import SnapKit

class NCChatDetailViewController: UIViewController {
    
    var chatUserId: String?
    
    var conversation: IMConversation?
    
    var messages: Array<IMMessage>?
    
    //
    var tableView: UITableView?
    
    var chatView: NCChatInputView?

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
        //
        createConversation()
        
        //
        addMsgObserver()
        //
        addKeyBoardObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func setup() {
        view.backgroundColor = UIColor().nc_bgColor
        navigationItem.title = chatUserId
        navigationItem.largeTitleDisplayMode = .never;
        //
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.register(NCChatItemCell.self, forCellReuseIdentifier: "NCChatItemCell")
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 60
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        view.addSubview(tableView!)
        let chatViewF = CGRect(x: 0, y: view.bounds.height-view.safeAreaInsets.bottom-50, width: view.bounds.width, height: 50)
        chatView = NCChatInputView(frame:chatViewF)
        chatView?.delegate = self
        view.addSubview(chatView!)
        //
        tableView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        chatView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(tableView!.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        })
        
    }
    func createConversation() {
        do {
            try NCLoginUser.shared.imuser!.createConversation(clientIDs: [chatUserId!], name: chatUserId, isUnique: true, completion: { (result) in
                switch result {
                case .success(value: let conversation):
                    self.conversation = conversation
                    self.fetchConversation()
                case .failure(error: let error):
                    print(error)
                }
            })
        } catch {
            print(error)
        }
    }
    func fetchConversation() {
        do {
            try conversation?.queryMessage(completion: { (result) in
                switch result {
                case .success(value: let messages):
                    self.messages = messages
                    self.tableView?.reloadData()
                    break
                case .failure(error: let error):
                    print(error)
                }
            })
        } catch {
            
        }
    }
    func addMsgObserver(){
        NCLoginUser.shared.imuser!.delegate = self as IMClientDelegate
    }
    
    func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (noti) in
            if let info = noti.userInfo {
                let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                
                self.chatView?.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(self.tableView!.snp.bottom).offset(-frame.height+self.view.safeAreaInsets.bottom)
                })
                self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height+self.view.safeAreaInsets.bottom, right: 0)
                if self.messages!.count > 0 {
                    self.tableView?.scrollToRow(at: IndexPath(item: self.messages!.count-1, section: 0), at: .bottom, animated: true)
                }
                
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (noti) in
            if let info = noti.userInfo {
                _ = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                
                self.chatView?.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(self.tableView!.snp.bottom)
                })
                self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
                if self.messages!.count > 0 {
                    self.tableView?.scrollToRow(at: IndexPath(item: self.messages!.count-1, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    
}

extension NCChatDetailViewController: IMClientDelegate {
    func client(_ client: IMClient, event: IMClientEvent) {
        
    }
    
    func client(_ client: IMClient, conversation: IMConversation, event: IMConversationEvent) {
        if conversation.ID == self.conversation?.ID {
            fetchConversation()
        }
    }
}

extension NCChatDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = messages {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NCChatItemCell")as!NCChatItemCell
        cell.deliverMessage(msg: msg)
        return cell
    }
}

extension NCChatDetailViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        chatView?.textFild?.resignFirstResponder()
    }
}

extension NCChatDetailViewController: NCChatInputViewDelegate {
    func chatInputView(ChatInputView: NCChatInputView, sendText: String) {
        if sendText == "" {
            return
        }
        do {
            let textMessage = IMTextMessage(text: sendText)
            try conversation!.send(message: textMessage) { (result) in
                switch result {
                case .success:
                    break
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
}
