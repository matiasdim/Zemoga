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
    static let baseURL = ""
    
    static func baseGetRequest(path: String, callback: @escaping (Any?) -> ()) {
        if let url = URL(string: "\(Self.baseURL)\(path)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest = try! JSONEncoding.default.encode(urlRequest, with: nil)
            
            AF.request(urlRequest).responseJSON { (response) in
                if let value = response.value {
                    callback(value)
                }
            }
        } else {
            callback(nil)
        }
    }
    
    static func isInternetReachable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
