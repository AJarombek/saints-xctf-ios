//
//  FnClient.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/19/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper
import os.log

class FnClient {
    
    private static let logTag = OSLog(subsystem: "SaintsXCTF.APIClient.FnClient", category: "FnClient")
    
    private static var fnBaseUrl: String {
        switch NetworkEnvironment().environment {
        case .localUITestStub:
            return "http://localhost:9082"
        case .local:
            return "http://localhost:5002"
        case .localEmail, .development:
            return "http://dev.fn.saintsxctf.com"
        case .production:
            return "http://fn.saintsxctf.com"
        }
    }
    
    // MARK: - POST Requests
    
    /**
     Handle POST Requests to send a welcome email to new users.
     - parameters:
         - email: Email address to send the welcome email to.
         - firstName: First name of the new user.
         - lastName: Last name of the new user.
         - completion: Callback function which is invoked once the POST request is fulfilled.
     */
    public static func emailWelcomePostRequest(
        email: String,
        firstName: String,
        lastName: String,
        completion: @escaping (FnResult?) -> Void
    ) {
        let emailWelcomeEndpoint = "\(fnBaseUrl)/email/welcome"
        guard let url = URL(string: emailWelcomeEndpoint) else {
            os_log("Error, Cannot create URL.", log: FnClient.logTag, type: .error)
            return
        }
        
        var requestBody: String?
        
        do {
            let requestBodyDictionary: [String: String] = [
                "email": email,
                "firstName": firstName,
                "lastName": lastName
            ]
            let requestBodyJSON = try JSONSerialization.data(withJSONObject: requestBodyDictionary, options: [])
            requestBody = String(data: requestBodyJSON, encoding: String.Encoding.utf8)
        } catch {
            os_log("Error, Failed to Create Request Body JSON.", log: FnClient.logTag, type: .error)
            return
        }
        
        APIRequest.post(withURL: url, andJson: requestBody ?? "", fromController: nil, authRequired: false) {
            (json) -> Void in
            
            if let result: FnResult = Mapper<FnResult>().map(JSONString: json ?? "") {
                os_log("%@", log: FnClient.logTag, type: .debug, result.toJSONString()!)
                
                OperationQueue.main.addOperation {
                    completion(result)
                }
            } else {
                os_log("Email Result Conversion Failed.", log: FnClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle POST Requests to send a user's report/feedback to my email.
     - parameters:
         - firstName: First name of the user making the report.
         - lastName: Last name of the user making the report.
         - report: Text body of the report.
         - completion: Callback function which is invoked once the POST request is fulfilled.
     */
    public static func emailReportPostRequest(
        firstName: String,
        lastName: String,
        report: String,
        completion: @escaping (FnResult?) -> Void
    ) {
        let emailReportEndpoint = "\(fnBaseUrl)/email/report"
        guard let url = URL(string: emailReportEndpoint) else {
            os_log("Error, Cannot create URL.", log: FnClient.logTag, type: .error)
            return
        }
        
        var requestBody: String?
        
        do {
            let requestBodyDictionary: [String: String] = ["firstName": firstName, "lastName": lastName, "report": report]
            let requestBodyJSON = try JSONSerialization.data(withJSONObject: requestBodyDictionary, options: [])
            requestBody = String(data: requestBodyJSON, encoding: String.Encoding.utf8)
        } catch {
            os_log("Error, Failed to Create Request Body JSON.", log: FnClient.logTag, type: .error)
            return
        }
        
        APIRequest.post(withURL: url, andJson: requestBody ?? "", fromController: nil, authRequired: true, authToken: UserJWT.jwt) {
            (json) -> Void in
            
            if let result: FnResult = Mapper<FnResult>().map(JSONString: json ?? "") {
                os_log("%@", log: FnClient.logTag, type: .debug, result.toJSONString()!)
                
                OperationQueue.main.addOperation {
                    completion(result)
                }
            } else {
                os_log("Email Result Conversion Failed.", log: FnClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle POST Requests to upload a profile picture.
     - parameters:
         - base64Image: Base64 encoded profile picture image.
         - filename: Name of the profile picture file.
         - username: Username of the user who the profile picture is associated with.
         - completion: Callback function which is invoked once the POST request is fulfilled.
     */
    public static func uassetUserPostRequest(
        base64Image: String,
        filename: String,
        username: String,
        completion: @escaping (FnResult?) -> Void
    ) {
        
        let emailReportEndpoint = "\(fnBaseUrl)/uasset/user"
        guard let url = URL(string: emailReportEndpoint) else {
            os_log("Error, Cannot create URL.", log: FnClient.logTag, type: .error)
            return
        }
        
        var requestBody: String?
        
        do {
            let requestBodyDictionary: [String: String] = ["base64Image": base64Image, "fileName": filename, "username": username]
            let requestBodyJSON = try JSONSerialization.data(withJSONObject: requestBodyDictionary, options: [])
            requestBody = String(data: requestBodyJSON, encoding: String.Encoding.utf8)
        } catch {
            os_log("Error, Failed to Create Request Body JSON.", log: FnClient.logTag, type: .error)
            return
        }
        
        APIRequest.post(withURL: url, andJson: requestBody ?? "", fromController: nil, authRequired: true, authToken: UserJWT.jwt) {
            (json) -> Void in
            
            if let result: FnResult = Mapper<FnResult>().map(JSONString: json ?? "") {
                os_log("%@", log: FnClient.logTag, type: .debug, result.toJSONString()!)
                
                OperationQueue.main.addOperation {
                    completion(result)
                }
            } else {
                os_log("User Conversion Failed.", log: FnClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
}
