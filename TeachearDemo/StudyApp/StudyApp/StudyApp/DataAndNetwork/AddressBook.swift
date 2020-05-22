//
//  AddressBook.swift
//  StudyApp
//
//  Created by 曾智辉 on 2020/3/23.
//  Copyright © 2020 曾智辉. All rights reserved.
//

import Foundation

struct AddressBook: Codable {
    var name: String
    var age: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "address_name"
        case age
    }
}
