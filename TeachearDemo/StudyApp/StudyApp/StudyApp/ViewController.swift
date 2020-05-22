//
//  ViewController.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/2/8.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import UIKit

enum ElementType: String {
    case Label = "Label"
    case Button = "Button"
    case ImageView = "ImageView"
    case CALayer = "CALayer"
    case ScrollView = "ScrollView"
    
    func viewController() -> UIViewController {
        switch self {
        case .Label:
            return LabelViewController()
         case .Button:
            return ButtonViewController()
        case .ScrollView:
            return ScrollViewController()
        case .ImageView:
            return ImageViewController()
        case .CALayer:
            return LayerController()
        }
    }
}

enum Layout: String {
    case Frame = "Frame"
    case AutoLayout = "AutoLayout"
    case SnapKit = "SnapKit"
    case VFL = "VFL"
    case StackView = "StackView"
    
    func viewController() -> UIViewController {
        switch self {
        case .Frame:
            return LayerController()
         case .AutoLayout:
            return LayoutViewController(layoutType: .AutoLayout)
        case .SnapKit:
            return LayoutViewController(layoutType: .SnapKit)
        case .VFL:
            return LayoutViewController(layoutType: .VFL)
        case .StackView:
            return LayoutViewController(layoutType: .StackViews)
        }
    }
}

enum Animation: String {
    case ViewAnimation = "ViewAnimation"
    case BasicAnimation = "BasicAnimation"
    case SpringAnimation = "SpringAnimation"
    case GroupAnimation = "GroupAnimation"
    case Transition = "Transition"
    
    func viewController() -> UIViewController {
        switch self {
        case .ViewAnimation:
            return AnimationViewController(type: 0)
         case .BasicAnimation:
            return AnimationViewController(type: 1)
        case .SpringAnimation:
            return AnimationViewController(type: 2)
        case .GroupAnimation:
            return AnimationViewController(type: 3)
        case .Transition:
            return AnimationViewController(type: 4)
        }
    }
}

enum Transation: String {
    case Push = "Push"
    case CustomPush = "CustomPush"
    
    case Present = "Present"
    case CustomPresent = "CustomPresent"
}

enum List: String {
    case TableView = "UITableView"
    case CollectionView = "UICollectionView"
    
    func viewController() -> UIViewController {
        switch self {
        case .TableView:
            return AddressBookController()
         case .CollectionView:
            return ColletionViewController()
        }
    }
}

class ViewController: UIViewController {

    var tableView: UITableView!
    var elementRows: [ElementType] = [.Label, .Button, .ImageView, .CALayer, .ScrollView]
    var layoutRows: [Layout] = [.Frame, .AutoLayout, .SnapKit, .VFL, .StackView]
    var animations: [Animation] = [.ViewAnimation, .BasicAnimation, .SpringAnimation, .GroupAnimation, .Transition]
    var transations: [Transation] = [.Push, .CustomPush, .Present, .CustomPresent]
    var lists: [List] = [.TableView, .CollectionView]
    var sections: [Array<Any>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "UI基础组件"
        sections = [elementRows, layoutRows, animations, transations, lists]
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationChanged(notification: Notification) {
        print(notification.name)
    }

    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning")
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var title = ""
        let rows = sections[indexPath.section]
        if let tmpArray = rows as? [ElementType] {
            title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [Layout] {
            title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [Animation] {
            title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [Transation] {
            title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [List] {
            title = tmpArray[indexPath.row].rawValue
        }
        cell.textLabel?.text = title as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        var tmpVC: UIViewController!
        let rows = sections[indexPath.section]
        if let tmpArray = rows as? [ElementType] {
            tmpVC = tmpArray[indexPath.row].viewController()
            tmpVC.title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [Layout] {
            tmpVC = tmpArray[indexPath.row].viewController()
            tmpVC.title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [Animation] {
            tmpVC = tmpArray[indexPath.row].viewController()
            tmpVC.title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [List] {
            tmpVC = tmpArray[indexPath.row].viewController()
            tmpVC.title = tmpArray[indexPath.row].rawValue
        } else if let tmpArray = rows as? [Transation] {
            switch tmpArray[indexPath.row] {
            case .Push:
                tmpVC = BaseViewController()
                tmpVC.title = tmpArray[indexPath.row].rawValue
            case .Present:
                tmpVC = PresentViewController()
                tmpVC.title = tmpArray[indexPath.row].rawValue
                let navVC = UINavigationController(rootViewController: tmpVC)
//                navVC.modalPresentationStyle = .fullScreen
                navVC.modalTransitionStyle = .flipHorizontal
                navVC.modalPresentationCapturesStatusBarAppearance = true
                self.present(navVC, animated: true, completion: nil)
                return
            case .CustomPresent:
                tmpVC = CustomPresentTransitionViewController()
                tmpVC.title = tmpArray[indexPath.row].rawValue
                tmpVC.modalPresentationStyle = .fullScreen
                self.present(tmpVC, animated: true, completion: nil)
                return
            case .CustomPush:
                let pushVC = CustomPushTransitionViewController()
                pushVC.title = tmpArray[indexPath.row].rawValue
                self.navigationController?.delegate = pushVC
                tmpVC = pushVC
            }
        }
        self.navigationController?.pushViewController(tmpVC, animated: true)
    }
    
}
