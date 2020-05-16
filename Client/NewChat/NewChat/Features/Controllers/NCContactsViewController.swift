//
//  NCContactsViewController.swift
//  NewChat
//
//  Created by luo on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

class NCContactsViewController: UIViewController {
    
    //
    var tableView: UITableView?
    
    /// 数据源
    var dataSourceArr = [Array<Dictionary<String, String>>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
        //
        fetchData()
    }
    
    private func setup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        //
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.register(NCContactCell.self, forCellReuseIdentifier: "NCContactCell")
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 60
        tableView?.delegate = self as! UITableViewDelegate
        view.addSubview(tableView!)
    }
    
    public func fetchData(){
        NCNet.fetchContactsList { (success, data) in
            //
            if !success {
                //数据库查找
                self.dataSourceArr = NCDataBase.shared.queryUsers(userId: "", isAll: true)
                self.tableView?.reloadData()
                return
            }
            //
            if data == nil {
                return
            }
            //
            do {
                
                self.dataSourceArr = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Array<Dictionary<String, String>>] ?? [])
                self.tableView?.reloadData()
                //插入数据库
                NCDataBase.shared.insertUser(users: self.dataSourceArr)
            } catch {
               
            }
            
        }
    }
}

extension NCContactsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contacts = dataSourceArr[section]
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contacts = dataSourceArr[indexPath.section]
        let user = contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NCContactCell")as!NCContactCell
        cell.name_label?.text = user["nickName"]
        if let header = UIImage(named:user["id"] ?? "") {
            cell.header_imageView?.image = header
        }else {
            cell.header_imageView?.image = UIImage(named: "user")
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let contacts = dataSourceArr[section]
        let user = contacts.first;
        let name = user?["id"]
        return name?.prefix(1).uppercased()
    }
    
}

extension NCContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let contact = NCContactDetailViewController()
        let contacts = dataSourceArr[indexPath.section]
        let user = contacts[indexPath.row]
        contact.hidesBottomBarWhenPushed = true
        contact.delegate = self as! NCContactDetailViewControllerDelegate
        contact.user = user
        navigationController?.pushViewController(contact, animated: true)
    }
}

extension NCContactsViewController: NCContactDetailViewControllerDelegate {
    func contactDetailViewController(contactDetailViewController: NCContactDetailViewController, updateUser: Dictionary<String, String>) {
        fetchData()
    }
}
