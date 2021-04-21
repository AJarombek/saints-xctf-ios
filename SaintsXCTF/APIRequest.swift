//
//  APIResponse.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper
import os.log

/**
 Class with helper methods to make HTTP API requests
 */
class APIRequest {
    
    private static let logTag = OSLog(subsystem: "SaintsXCTF.APIClient.APIRequest", category: "APIRequest")
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    /**
     Handle HTTP GET Requests to the API.  Fetching data is an asynchronous process, so the
     @escaping annotation lets the compiler know that the closure might not get called immediately
     - parameters:
     - url: the HTTP API URL to invoke
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func get(withURL url: URL, completion: @escaping (String) -> Void) {
        var urlRequest = URLRequest(url: url)
        
        // add the credentials and accept type to the url request
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
                
            // Check for any errors
            guard error == nil else {
                os_log("Error with GET request.", log: APIRequest.logTag, type: .error)
                print(error!)
                return
            }
        
            // Check the response data
            guard let responseData = data else {
                os_log("Error, did not receive data.", log: APIRequest.logTag, type: .error)
                return
            }
            
            print(responseData)
            
            let jsonString: String? = String(data: responseData, encoding: String.Encoding.utf8)
                
            guard let json = jsonString else {
                
                os_log("Error, Map Conversion Failed.", log: APIRequest.logTag, type: .error)
                return
                    
            }
            
            os_log("%@", log: APIRequest.logTag, type: .debug, json)
                
            OperationQueue.main.addOperation {
                completion(json)
            }
        }
        task.resume()
    }
    
    /**
     Handle HTTP POST Requests to the API
     - parameters:
     - url: the HTTP API URL to invoke
     - json: JSON to use as the HTTP request body
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func post(withURL url: URL, andJson json: String,
                            completion: @escaping (String) -> Void) {
        var urlrequest = URLRequest(url: url)
        urlrequest.httpMethod = "POST"
        
        // Get the data for the httpbody from the JSON
        let body: Data = json.data(using: .utf8)!
        urlrequest.httpBody = body
        
        // add the credentials and accept type to the url request
        urlrequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlrequest) {
            (data, response, error) -> Void in
                
            // Check for any errors
            guard error == nil else {
                os_log("Error with POST request.", log: APIRequest.logTag, type: .error)
                print(error!)
                return
            }
            
            // Check the response data
            guard let responseData = data else {
                os_log("Error, did not receive data.", log: APIRequest.logTag, type: .error)
                return
            }
                
            print(responseData)
                
            let jsonString: String? = String(data: responseData, encoding: String.Encoding.utf8)
            
            guard let json = jsonString else {
                
                os_log("Error, Map Conversion Failed.", log: APIRequest.logTag, type: .error)
                return
                
            }
            
            OperationQueue.main.addOperation {
                completion(json)
            }
        }
        task.resume()
    }
    
    /**
     Handle HTTP PUT Requests to the API
     - parameters:
     - url: the HTTP API URL to invoke
     - json: JSON to use as the HTTP request body
     - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
    public static func put(withURL url: URL, andJson json: String,
                           completion: @escaping (String) -> Void) {
        var urlrequest = URLRequest(url: url)
        urlrequest.httpMethod = "PUT"
        
        // Get the data for the httpbody from the JSON
        let body: Data = json.data(using: .utf8)!
        urlrequest.httpBody = body
        
        // add the credentials and accept type to the url request
        urlrequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlrequest) {
            (data, response, error) -> Void in
                
            // Check for any errors
            guard error == nil else {
                os_log("Error with PUT request.", log: APIRequest.logTag, type: .error)
                print(error!)
                return
            }
                
            // Check the response data
            guard let responseData = data else {
                os_log("Error, did not receive data.", log: APIRequest.logTag, type: .error)
                return
            }
                
            let jsonString: String? = String(data: responseData, encoding: String.Encoding.utf8)
            
            os_log("%@", log: APIRequest.logTag, type: .debug, jsonString ?? "")
                
            guard let json = jsonString else {
                
                os_log("Error, Map Conversion Failed.", log: APIRequest.logTag, type: .error)
                return
                    
            }
                
            OperationQueue.main.addOperation {
                completion(json)
            }
        }
        task.resume()
    }
    
    /**
     Handle HTTP DELETE Requests to the API
     - parameters:
     - url: the HTTP API URL to invoke
     - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
    public static func delete(withURL url: URL, completion: @escaping (Bool) -> Void) {
        var urlrequest = URLRequest(url: url)
        urlrequest.httpMethod = "DELETE"
        
        // add the credentials and accept type to the url request
        urlrequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlrequest) {
            (data, response, error) -> Void in
            
            guard let _ = data else {
                os_log("Error, Delete Request failed", log: APIRequest.logTag, type: .error)
                return
            }
            os_log("Delete Request Successful!", log: APIRequest.logTag, type: .debug)
            
            OperationQueue.main.addOperation {
                completion(true)
            }
        }
        task.resume()
    }
}
