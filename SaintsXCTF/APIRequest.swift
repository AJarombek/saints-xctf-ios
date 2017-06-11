//
//  APIResponse.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

enum JSONError: Error {
    case jsonConversionError
}

class APIRequest {
    
    private static let logTag = "APIRequest:"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // Handle HTTP GET Requests to the API
    // Add a Completion closure.  Fetching data is an asynchronous process, so the
    // @escaping annotation lets the compiler know that the closure might not get called immediately
    public static func get(withURL url: URL, completion: @escaping (AnyObject) -> Void) {
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            do {
                
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
                
                print(responseData)
            
                // Serialize with JSON
                let json: AnyObject? = try JSONSerialization.jsonObject(
                    with: responseData, options: .mutableContainers) as AnyObject
                
                if let j: AnyObject = json {
                    
                    OperationQueue.main.addOperation {
                        completion(j)
                    }
                    
                } else {
                    print("\(logTag) Error, Map Conversion Failed")
                    return
                }
            
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    // Handle HTTP POST Requests to the API
    public static func post(withURL url: String) {
        
    }
    
    // Handle HTTP PUT Requests to the API
    public static func put(withURL url: String) {
        
    }
    
    // Handle HTTP DELETE Requests to the API
    public static func delete(withURL url: String) {
        
    }
}
