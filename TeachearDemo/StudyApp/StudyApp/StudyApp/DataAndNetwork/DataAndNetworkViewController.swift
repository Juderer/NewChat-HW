//
//  DataAndNetworkViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/22.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

class DataAndNetworkViewController: BaseViewController {
    
    enum CellType: String, CaseIterable {
        case FilePath = "File Path"
        case CoreData = "Core Data"
        case Network = "Network"
    }
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DataAndNetwork"
        setupTableView()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorEffect = UIBlurEffect(style: .dark)
    }
}

extension DataAndNetworkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = CellType.allCases[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var tmpVC: UIViewController!
        switch CellType.allCases[indexPath.row] {
        case .FilePath:
            tmpVC = FilePathViewController()
        case .CoreData:
            tmpVC = CoreDataViewController()
        case .Network:
            tmpVC = NetworkViewController()
            
        }
        self.navigationController?.pushViewController(tmpVC, animated: true)
    }
    
}
