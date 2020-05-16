//
//  NCFeedSendViewController.swift
//  NewChat
//
//  Created by lu on 2020/4/27.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

protocol NCFeedSendViewControllerDelegate:NSObjectProtocol {
    func feedSendViewController(feedSendViewController: NCFeedSendViewController,sendFinish:Dictionary<String, Any>)
}

class NCFeedSendViewController: UIViewController {

    var textView: UITextView?
    var location_btn: UIButton?
    weak var deleagte: NCFeedSendViewControllerDelegate?
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setup()
        
        //location
        locationManager = CLLocationManager()
        locationManager?.distanceFilter = 300
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
//        locationManager!.allowsBackgroundLocationUpdates = true
        locationManager!.requestWhenInUseAuthorization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager!.startUpdatingLocation()
    }
    func setup() {
        //
        navigationItem.largeTitleDisplayMode = .never;
        view.backgroundColor = UIColor.white
        let sendItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(sendItemClick))
        navigationItem.rightBarButtonItem = sendItem
        //
        textView = UITextView(frame: .zero)
        textView?.backgroundColor = UIColor().nc_bgColor
        view.addSubview(textView!)
        location_btn = UIButton(type: .custom)
        location_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        location_btn?.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        location_btn?.backgroundColor = UIColor().nc_bgColor
        location_btn?.layer.cornerRadius = 5;
        location_btn?.setTitleColor(UIColor().nc_color3, for: .normal)
        location_btn?.setImage(UIImage(named: "location"), for: .normal)
        view.addSubview(location_btn!)
        
        //
        textView?.snp.makeConstraints({ (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(200)
        })
        location_btn?.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(textView!.snp.bottom).offset(10)
        })
    }
    
    @objc func sendItemClick() {
        guard textView?.text != "" else {
            return
        }
        let location = location_btn?.title(for: .normal) ?? ""
            
        NCNet.feedSend(params: ["userId":NCLoginUser.shared.userId,"content":textView!.text,"location":location]) { (success, data) in
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
                self.deleagte?.feedSendViewController(feedSendViewController: self, sendFinish: feed)
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("JSONSerialization error:", error)
            }
        }
    }
    
}

extension NCFeedSendViewController : CLLocationManagerDelegate{
    
    //定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        //地理编码的类
        let gecoder = CLGeocoder()
        if let location = location {
            //反地理编码 转换成 具体的地址
            gecoder.reverseGeocodeLocation(location) { (placeMarks, error) in
                //CLPlacemark －－ 国家 城市 街道
                let placeMark = placeMarks?.first
                if let placeMark = placeMark{
                    print("\(placeMark.country!) -- \(placeMark.name!) -- \(placeMark.locality!)")
                    self.location_btn?.setTitle("\(placeMark.locality!)·\(placeMark.name!)", for: .normal)
                }
            }
        }
        locationManager!.stopUpdatingLocation()
    }
    
    //定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
}
