//
//  AddressBookController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/22.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class AddressBookController: BaseViewController {
    
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var addressArray: [AddressBookModel]!
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        self.navigationItem.titleView = UIView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backAtion))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editAction))
        setupData()
        setupTableView()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        
    }
    
    func setupData() {
        addressArray = [AddressBookModel]()
        addressArray.append(AddressBookModel(name: "Bob", iconName: ""))
        addressArray.append(AddressBookModel(name: "Cristy", iconName: ""))
        addressArray.append(AddressBookModel(name: "Dell", iconName: ""))
        for index in 0..<15 {
            addressArray.append(AddressBookModel(name: "name\(index)", iconName: ""))
        }
    }
    
    func setupTableView() {
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: self.view.bounds, style: .plain)
        } else {
            // Fallback on earlier versions
            tableView = UITableView(frame: self.view.bounds, style: .plain)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(AddressBookCell.self, forCellReuseIdentifier: "AddressBookCell")
        tableView.register(LoadMoreTableCell.self, forCellReuseIdentifier: "LoadMoreTableCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        tableView.separatorColor = UIColor.red
        
        tableView.separatorEffect = UIBlurEffect(style: .dark)
        
        addPullToRefresh()
    }
    
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新中")
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func editAction() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editAction))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(editAction))
//            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.setEditing(true, animated: true)
        }
    }
    
    @objc func backAtion() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddressBookController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addressArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressBookCell", for: indexPath) as! AddressBookCell
            if indexPath.row < addressArray.count {
                cell.textLabel?.text = addressArray[indexPath.row].name
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreTableCell", for: indexPath) as! LoadMoreTableCell
            cell.loadingView.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    //edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            addressArray.append(AddressBookModel(name: "Add", iconName: ""))
            tableView.reloadData()
        } else if editingStyle == .delete {
            addressArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
//    move
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        addressArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let loadMoreCell = cell as? LoadMoreTableCell {
                loadMoreCell.loadingView.startAnimating()
                loadMore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let loadMoreCell = cell as? LoadMoreTableCell {
                loadMoreCell.loadingView.stopAnimating()
            }
        }
    }
}


extension AddressBookController {
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        print("handleRefresh")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            let model = AddressBookModel(name: "Add", iconName: "Add")
            self.addressArray.append(model)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadMore() {
        if !isLoading {
            print("loading more")
            isLoading = true
            DispatchQueue.global().async {
                sleep(2)
                let count = self.addressArray.count
                for index in 0..<5 {
                    self.addressArray.append(AddressBookModel(name: "name\(count + index)", iconName: ""))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }
            
        }
    }
}
