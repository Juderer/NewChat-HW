//
//  ViewController.swift
//  NewChat
//
//  Created by zhu on 2020/4/19.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        AF.request("http://localhost:9090/users", method: .get).responseJSON{response in
//            print(response)
//        }
        let params = ["id":"xudongdong","nickName":"","sex":"","adress":"","email":""]
        
        AF.request("http://139.196.138.145:9090/users", method: .post, parameters:params ).responseJSON { (respone) in
            print(respone)
        }
    }


}

