//
//  Comment.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/11/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var id: Int
    var postId: Int
    var name: String
    var email: String
    var body: String
    
    init(id: Int, name: String, email: String, postId: Int, body: String) {
        self.id = id
        self.name = name
        self.email = email
        self.postId = postId
        self.body = body
    }
    
    // To map Json key to my model keys
    // (The API used for thisexample match the model names, but still is good practice to keep this method updated for when API changes its keynames)
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case postId = "postId"
        case body = "body"
    }
    
    static func getComments(for post: Post, callback: @escaping ([Comment]) -> ()) {
        NetworkManager.getPostComments(postId: post.id) { (response) in
            if let response = response, let comments = CommonDecoder.decodeObject(objectType: [Comment].self, data: response) {
                callback(comments)
            } else {
                callback([])
            }
        }
    }
}
