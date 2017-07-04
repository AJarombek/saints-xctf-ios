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

// Entend the String class to have base 64 functionality
extension String {
    // Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    // Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
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
    public static func get(withURL url: URL, completion: @escaping (String) -> Void) {
        var urlRequest = URLRequest(url: url)
        
        // Get the necessary credentials for the API Request
        let cred = Credentials()

        // encode the credentials
        var credsJSON: String? = cred.toJSONString()
        credsJSON = credsJSON?.toBase64()
        
        // add the credentials and accept type to the url request
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue(credsJSON!, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
                
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
            
            let jsonString: String? = String(data: responseData, encoding: String.Encoding.utf8)
                
            guard let json = jsonString else {
                    
                print("\(logTag) Error, Map Conversion Failed")
                return
                    
            }
                
            OperationQueue.main.addOperation {
                completion(json)
            }
        }
        task.resume()
    }
    
    // Handle HTTP POST Requests to the API
    public static func post(withURL url: URL, andObject object: Any,
                            completion: @escaping (String) -> Void) {
        var urlrequest = URLRequest(url: url)
        urlrequest.httpMethod = "POST"
        
        // Object to hold the JSON string
        let jsonObject: Data
        
        // Serialize the object into JSON for the URL Request
        do {
            jsonObject = try JSONSerialization.data(withJSONObject: object, options: [])
            urlrequest.httpBody = jsonObject
        } catch {
            print("\(logTag) Error, cannot produce JSON from object")
            return
        }
        
        let task = session.dataTask(with: urlrequest) {
            (data, response, error) -> Void in
                
            // Check for any errors
            guard error == nil else {
                print("\(logTag) Error with POST request")
                print(error!)
                return
            }
            
            // Check the response data
            guard let responseData = data else {
                print("\(logTag) Error, did not receive data")
                return
            }
                
            print(responseData)
                
            let jsonString: String? = String(data: responseData, encoding: String.Encoding.utf8)
            
            guard let json = jsonString else {
                
                print("\(logTag) Error, Map Conversion Failed")
                return
                
            }
            
            OperationQueue.main.addOperation {
                completion(json)
            }
        }
        task.resume()
    }
    
    // Handle HTTP PUT Requests to the API
    public static func put(withURL url: URL, andObject object: Any,
                           completion: @escaping (String) -> Void) {
        var urlrequest = URLRequest(url: url)
        urlrequest.httpMethod = "PUT"
        
        let jsonObject: Data
        
        do {
            jsonObject = try JSONSerialization.data(withJSONObject: object, options: [])
            urlrequest.httpBody = jsonObject
        } catch {
            print("\(logTag) Error, cannot produce JSON from object")
            return
        }
        
        let task = session.dataTask(with: urlrequest) {
            (data, response, error) -> Void in
                
            // Check for any errors
            guard error == nil else {
                print("\(logTag) Error with PUT request")
                print(error!)
                return
            }
                
            // Check the response data
            guard let responseData = data else {
                print("\(logTag) Error, did not receive data")
                return
            }
                
            print(responseData)
                
            let jsonString: String? = String(data: responseData, encoding: String.Encoding.utf8)
                
            guard let json = jsonString else {
                    
                print("\(logTag) Error, Map Conversion Failed")
                return
                    
            }
                
            OperationQueue.main.addOperation {
                completion(json)
            }
        }
        task.resume()
    }
    
    // Handle HTTP DELETE Requests to the API
    public static func delete(withURL url: URL, completion: @escaping (Bool) -> Void) {
        var urlrequest = URLRequest(url: url)
        urlrequest.httpMethod = "DELETE"
        
        let task = session.dataTask(with: urlrequest) {
            (data, response, error) -> Void in
            
            guard let _ = data else {
                print("\(logTag) Error, Delete Request failed")
                return
            }
            print("\(logTag) Delete Request Successful!")
            
            OperationQueue.main.addOperation {
                completion(true)
            }
        }
        task.resume()
    }
}
