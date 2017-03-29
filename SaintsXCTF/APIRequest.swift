//
//  APIResponse.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

class APIRequest {
    
    private static let logTag = "APIRequest:"
    
    public static func get(withURL url: URL) {
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                print("\(logTag) Error with GET request")
                print(error!)
                return
            }
            
            // Check the response data
            guard let responseData = data else {
                print("\(logTag) Error, did not receive data")
                return
            }
        }
    }
    
    public static func post(withURL url: String) {
        
    }
    
    public static func put(withURL url: String) {
        
    }
    
    public static func delete(withURL url: String) {
        
    }
}
