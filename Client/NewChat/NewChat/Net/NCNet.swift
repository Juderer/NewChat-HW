//
//  NCNet.swift
//  NewChat
//
//  Created by zhu on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import Alamofire

class NCNet {
    
    /// 服务器地址
    public class var BaseURL: String {
//        return "http://localhost:9090/"
        return "http://139.196.138.145:9090/"
    }
    //获取联系人列表Api
    public class var contactsListApi:String {
        return "users"
    }
    
    //获取联系人列表Api
    public class var modifyUserApi:String {
        return "users"
    }
    
    public class var allFeedsApi: String {
        return "feeds"
    }
    
    public class var feedFavorApi: String {
        return "feeds/favor"
    }
    
    public class var feedCommentApi: String {
        return "feeds/comment"
    }
    
    public class var feedSendApi: String {
        return "feeds/send"
    }
    
    
    /// 获取好友列表
    /// - Parameter callback: callback
    public class func fetchContactsList(callback: @escaping (_ success: Bool,_ data: Data?) -> Void){
        let url = BaseURL+contactsListApi
        AF.request(url,method: .get
        ).responseJSON { (respone) in
            if respone.error != nil {
                callback(false,nil)
                return
            }
            callback(true,respone.data)
        }
    }
    
    public class func fetchSomeUser(userId: String,callback: @escaping (_ success: Bool,_ data: Data?) -> Void){
        let url = BaseURL+contactsListApi+"/\(userId)"
        AF.request(url,method: .get
        ).responseJSON { (respone) in
            if respone.error != nil {
                callback(false,nil)
                return
            }
            callback(true,respone.data)
        }
    }
    
    
    public class func modifyUserInfo(user: Dictionary<String, String>,callback:@escaping (_ success: Bool,_ data: Data?) -> Void) {
        let url = BaseURL+modifyUserApi
        AF.request(url,method: .post,parameters: user).responseJSON { (respone) in
            if respone.error != nil {
                callback(false,nil)
                return
            }
            callback(true,respone.data)
        }
    }
    
    ///
    /// - Parameter callback: callback
    public class func fetchFeedsList(callback: @escaping (_ success: Bool,_ data: Data?) -> Void){
        let url = BaseURL+allFeedsApi
        AF.request(url,method: .get
        ).responseJSON { (respone) in
            if respone.error != nil {
                callback(false,nil)
                return
            }
            callback(true,respone.data)
        }
    }
    
    public class func feedFavor(params: Dictionary<String, Any>,callback:@escaping (_ success: Bool,_ data: Data?) -> Void) {
        let url = BaseURL+feedFavorApi
        AF.request(url,method: .post,parameters: params).responseJSON { (respone) in
            if respone.error != nil {
                callback(false,nil)
                return
            }
            callback(true,respone.data)
        }
    }
    
    public class func feedComment(params: Dictionary<String, Any>,callback:@escaping (_ success: Bool,_ data: Data?) -> Void) {
        let url = BaseURL+feedCommentApi
        AF.request(url,method: .post,parameters: params).responseJSON { (respone) in
            if respone.error != nil {
                callback(false,nil)
                return
            }
            callback(true,respone.data)
        }
    }
    
    public class func feedSend(params: Dictionary<String, String>,callback:@escaping (_ success: Bool,_ data: Data?) -> Void) {
        let url = BaseURL+feedSendApi
        AF.request(url,method: .post,parameters: params).responseJSON { (respone) in
            if respone.error != nil {
                callback(false,nil)
                return
            }
            callback(true,respone.data)
        }
    }
}
