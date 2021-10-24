//
//  User.swift
//  InMemories
//
//  Created by Meraki on 24.10.2021.
//

import Foundation

struct User {
    let userName: String
    let userPhoto: String
    
    init(dictionary: [String: Any]) {
        self.userName = dictionary["userName"] as? String ?? ""
        self.userPhoto = dictionary["userPhoto"] as? String ?? ""
    }
}
