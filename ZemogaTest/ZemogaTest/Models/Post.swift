//
//  Post.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/11/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import Foundation

struct Post: Codable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
    var favorite: Bool?
    var unread: Bool?
        
    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.favorite = true
        self.unread = false
    }
    
    // To map Json key to my model keys
    // (The API used for thisexample match the model names, but still is good practice to keep this method updated for when API changes its keynames)
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case title = "title"
        case body = "body"
    }
    
    static func getPosts(callback: @escaping ([Post]?) -> ()) {
        NetworkManager.getPosts { (response) in
            if let response = response, let posts = CommonDecoder.decodeObject(objectType: [Post].self, data: response) {
                callback(posts)
            } else {
                callback(nil)
            }            
        }
    }
}
