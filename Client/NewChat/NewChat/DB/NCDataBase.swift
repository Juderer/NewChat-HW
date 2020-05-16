//
//  NCDataBase.swift
//  NewChat
//
//  Created by zhu on 2020/5/1.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SQLite

/// 数据库
class NCDataBase {
    static var DocmentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    static var shared = NCDataBase(path: "\(NCDataBase.DocmentPath)/NewChat.sqlite")
    var path: String
    
    var DB:Connection?
    
    var userTable:Table = Table("users")
    
    var feedTable: Table = Table("feeds")
    
    var commentTable: Table = Table("comments")
    
    var favorUserTable: Table = Table("favorUser")
    
    var commmentUserTable: Table = Table("commentUser")
    
    init(path:String) {
        self.path = path
        print(NCDataBase.DocmentPath)
        DB = try! Connection(self.path)
        //user
//        userTable = Table("users")
        self.createUserTable()
        //feed
//        feedTable = Table("feeds")
        self.createFeedTable()
        //commment
//        commentTable = Table("comments")
        self.createCommentTable()
        //favorUser
//        favorUserTable = Table("favorUser")
        self.createFavorUserTable()
        //commmentUser
//        commmentUserTable = Table("commentUser")
        self.createCommentUserTable()
        
    }
    func createUserTable() {
        let id = Expression<String>("id")
        let nickName = Expression<String?>("nickName")
        let email = Expression<String?>("email")
        let sex = Expression<String?>("sex")
        let adress = Expression<String?>("adress")
        try! DB!.run(userTable.create(ifNotExists: true) { (t) in
            t.column(id, primaryKey: true)
            t.column(nickName)
            t.column(email)
            t.column(sex)
            t.column(adress)
        })
    }
    func createFeedTable() {
        let id = Expression<Int>("id")
        let creatBy = Expression<String?>("creatBy")
        let creatAt = Expression<String?>("creatAt")
        let content = Expression<String?>("content")
        let location = Expression<String?>("location")
        try! DB!.run(feedTable.create(ifNotExists: true) { (t) in
            t.column(id, primaryKey: true)
            t.column(creatBy)
            t.column(creatAt)
            t.column(content)
            t.column(location)
        })
    }
    func createCommentTable() {
        let id = Expression<Int>("id")
        let content = Expression<String?>("content")
        let commentAt = Expression<String?>("commentAt")
        try! DB!.run(commentTable.create(ifNotExists: true) { (t) in
            t.column(id, primaryKey: true)
            t.column(content)
            t.column(commentAt)
        })
    }
    func createFavorUserTable() {
        let favorId = Expression<Int?>("favorId")
        let userId = Expression<String?>("userId")
        try! DB!.run(favorUserTable.create(ifNotExists: true) { (t) in
            t.column(favorId)
            t.column(userId)
        })
    }
    func createCommentUserTable() {
        let commentId = Expression<Int?>("commentId")
        let userId = Expression<String?>("userId")
        try! DB!.run(commmentUserTable.create(ifNotExists: true) { (t) in
            t.column(commentId)
            t.column(userId)
        })
    }
    
    public func insertUser(users: [Array<Dictionary<String,String>>]) -> Bool {
        //删除表数据
        cleanUsers()
        //插入数据
        for (index,arr) in users.enumerated() {
            for (ind,user) in arr.enumerated() {
                let rowid = try! DB!.run(userTable.insert(
                    Expression<String?>("email") <- user["email"] ?? "",
                    Expression<String>("id") <- user["id"] ?? "",
                    Expression<String?>("nickName") <- user["nickName"] ?? "",
                    Expression<String?>("sex") <- user["sex"] ?? "",
                    Expression<String?>("adress") <- user["adress"] ?? ""
                    )
                )
            }
        }
        
        return true
    }
    func queryUsers(userId:String?,isAll:Bool) -> [Array<Dictionary<String,String>>] {
        var allUsers = [Array<Dictionary<String,String>>]()
        for user in try! DB!.prepare(userTable) {
            var userDic = ["id":user[Expression<String>("id")] ?? ""
            ,
                "email":user[Expression<String?>("email")] ?? "",
                           "nickName":user[Expression<String?>("nickName")] ?? "",
                           "sex":user[Expression<String?>("sex")] ?? "",
                           "adress":user[Expression<String?>("adress")] ?? ""]
            allUsers.append([userDic])
            
        }
        
        return allUsers
    }

    func cleanUsers() -> Bool {
        try! DB!.run(userTable.delete())
        return true
    }

    func insertFeeds(feeds:Array<Dictionary<String,Any>>) -> Bool {
        for (index,feed) in feeds.enumerated() {
            //
            cleanFeeds()
            //
            cleanFavorUser()
            //
            cleanComments()
            //
            cleanFavorUser()
            //
            cleanCommentUsers()
            
            //
            let creatUser = feed["creatBy"] as!Dictionary<String,String>
            try! DB!.run(feedTable.insert(
                Expression<String?>("creatBy") <- creatUser["id"] ?? "",
                Expression<Int>("id") <- feed["id"] as? Int ?? 0,
                Expression<String?>("creatAt") <- feed["creatAt"] as? String ?? "",
                Expression<String?>("content") <- feed["content"] as? String ?? "",
                Expression<String?>("location") <- feed["location"] as? String ?? ""
                )
            )
            //
            let favorUser = feed["favortes"] as! Array<Dictionary<String,String>>
            for (_,user) in favorUser.enumerated() {
                try! DB!.run(favorUserTable.insert(
                    Expression<Int?>("favorId") <- feed["id"] as? Int ?? 0,
                    Expression<String?>("userId") <- user["id"] ?? ""
                    )
                )
            }
            //
            let comments = feed["comments"] as! Array<Dictionary<String,Any>>
            for (_,comment) in comments.enumerated() {
                //
                try! DB!.run(commentTable.insert(
                    Expression<Int>("id") <- comment["id"] as? Int ?? 0,
                    Expression<String?>("content") <- comment["content"] as? String ?? "",
                    Expression<String?>("commentAt") <- comment["commentAt"] as? String ?? ""
                    )
                )
                //
                let commentUser = comment["commentBy"] as? Dictionary<String,String>
                try! DB!.run(commmentUserTable.insert(
                    Expression<Int?>("commentId") <- comment["id"] as? Int ?? 0,
                    Expression<String?>("userId") <- commentUser!["id"] ?? ""
                    )
                )
            }
        }
        return true
    }

    func queryFeeds(feed:Int?,isAll: Bool) -> Array<Dictionary<String,Any>> {
        var allFeeds = Array<Dictionary<String,Any>>()
        
        for feed in try! DB!.prepare(feedTable) {
            //
            let creatByTable = userTable.filter(Expression<String>("id") == feed[Expression<String?>("creatBy")] ?? "")
            var createBy:Dictionary<String,String>?
            for user in try! DB!.prepare(creatByTable) {
                var userDic = [
                    "id":user[Expression<String>("id")] ?? "",
                    "email":user[Expression<String?>("email")] ?? "",
                    "nickName":user[Expression<String?>("nickName")] ?? "",
                    "sex":user[Expression<String?>("sex")] ?? "",
                    "adress":user[Expression<String?>("adress")] ?? ""]
                createBy = userDic
            }
            print(createBy)
            //
            let favorUserTa = favorUserTable.filter(Expression<Int>("favorId") == feed[Expression<Int>("id")] ?? 0)
            var favorUserIds = Array<String>()
            for favorUser in try! DB!.prepare(favorUserTa) {
                favorUserIds.append(favorUser[Expression<String>("userId")] ?? "")
            }
            var favorUsers = Array<Dictionary<String,String>>()
            for (_,userId) in favorUserIds.enumerated() {
                for user in try! DB!.prepare(userTable.filter(Expression<String>("id") == userId ?? "")) {
                    var userDic = [
                        "id":user[Expression<String>("id")] ?? "",
                        "email":user[Expression<String?>("email")] ?? "",
                        "nickName":user[Expression<String?>("nickName")] ?? "",
                        "sex":user[Expression<String?>("sex")] ?? "",
                        "adress":user[Expression<String?>("adress")] ?? ""]
                    favorUsers.append(userDic)
                }
            }
            print(favorUsers)
            
            //
            var dic = [
                "id":feed[Expression<Int>("id")] ?? 0,
                "creatBy":createBy,
                "creatAt":feed[Expression<String?>("creatAt")] ?? "",
                "content":feed[Expression<String?>("content")] ?? "",
                "location":feed[Expression<String?>("location")] ?? "",
                "favortes":favorUsers,
                "comments":[]
                ] as [String : Any]
            allFeeds.append(dic)
        }
        return allFeeds
    }

    func cleanFeeds() -> Bool {
        try! DB!.run(feedTable.delete())
        return true
    }
//
//    func insertComment(comment:Dictionary<String,Any>) -> Bool {
//
//    }
//
//    func queryCommnet(commentId: String) -> Dictionary<String,Any> {
//
//    }
    func cleanComments() -> Bool {
        try! DB!.run(commentTable.delete())
        return true
    }
//    func insertCommentUser(data: Dictionary<String,String>) -> Bool {
//
//    }
//    func queryCommentUsers(commentId: String) -> Array<String> {
//
//    }
    func cleanCommentUsers() -> Bool {
        try! DB!.run(commmentUserTable.delete())
        return true
    }
//    func insertFavorUser(data: Dictionary<String,String>) -> Bool {
//
//    }
//    func queryFavorUser(favorId: String) -> Array<String> {
//
//    }
    func cleanFavorUser() -> Bool {
        try! DB!.run(favorUserTable.delete())
        return true
    }
}
