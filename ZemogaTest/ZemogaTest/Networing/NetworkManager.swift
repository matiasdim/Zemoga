//
//  NetworkManager.swift
//  ZemogaTest
//
//  Created by Matías Gil Echavarría on 7/10/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkManager {    
    static let baseURL = "https://jsonplaceholder.typicode.com/"
    
    static func baseGetRequest(path: String, callback: @escaping (Data?) -> ()) {
        if let url = URL(string: "\(Self.baseURL)\(path)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest = try! JSONEncoding.default.encode(urlRequest, with: nil)
            
            AF.request(urlRequest).responseJSON { (response) in
                if let data = response.data {
                    callback(data)  
                } else {
                    callback(nil)
                }
            }
        } else {
            callback(nil)
        }
    }
    
    static func getPosts(callback: @escaping (Data?) -> ()) {
        Self.baseGetRequest(path: "posts", callback: callback)
    }
    
    static func getUser(userId: Int, callback: @escaping (Data?) -> ()) {
        Self.baseGetRequest(path: "users/\(userId)", callback: callback)
    }
    
    static func getPostComments(postId: Int, callback: @escaping (Data?) -> ()) {
        Self.baseGetRequest(path: "posts/\(postId)/comments", callback: callback)
    }
    
    static func isInternetReachable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

struct CommonDecoder {
    // Generic function to decode
    static func decodeObject<T: Decodable>(objectType: T.Type, data: Data) -> T? {
        do {
            return try JSONDecoder().decode(objectType, from: data)
        } catch {
            print("Could not decode")
            return nil
        }
    }
}
