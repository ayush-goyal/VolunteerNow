//
//  APIManager.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/8/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
}

typealias JSON = [String: AnyObject]

enum APIRequestError: String {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
}

class APIManager {
    static func jsonTaskWithRoute(_ route: String, usingHTTPMethod method: HTTPMethod, postData: [String: Any]?, completionHandler completion: @escaping (JSON?, APIRequestError?) -> Void) -> Void {
        let url = URL(string: route)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Headers
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // JSON Body
        if method == .post, let postData = postData {
            request.httpBody = try! JSONSerialization.data(withJSONObject: postData, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
            
        }
        task.resume()
    }
}
