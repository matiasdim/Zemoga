//
//  User.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/11/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int
    var name: String
    var email: String
    var phone: String
    var website: String
        
    init(id: Int, name: String, email: String, phone: String, website: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.website = website
    }
    
    // To map Json key to my model keys
    // (The API used for thisexample match the model names, but still is good practice to keep this method updated for when API changes its keynames)
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case website = "website"
    }
    
    static func getUsers(callback: @escaping ([User]?) -> ()) {
        NetworkManager.getUsers { (response) in
            if let response = response, let posts = CommonDecoder.decodeObject(objectType: [User].self, data: response) {
                callback(posts)
            } else {
                callback(nil)
            }
            
        }
    }
}
