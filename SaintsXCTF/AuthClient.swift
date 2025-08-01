//
//  AuthClient.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/19/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper
import os.log

class AuthClient {
    
    private static let logTag = OSLog(subsystem: "SaintsXCTF.APIClient.AuthClient", category: "AuthClient")
    
    private static var authBaseUrl: String {
        switch NetworkEnvironment().environment {
        case .localUITestStub:
            return "http://localhost:9081"
        case .local, .localEmail:
            return "http://localhost:5001"
        case .development:
            return "http://dev.auth.saintsxctf.com"
        case .production:
            return "https://auth.saintsxctf.com"
        }
    }
    
    // MARK: - POST Requests
    
    /**
     Handle POST Requests to get an authentication token (JWT).
     - parameters:
     - username: The username of the user that is signing in.
     - password: The password of the user that is signing in.
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func tokenPostRequest(withUsername username: String, password: String, completion: @escaping (AuthResult) -> Void) {
        
        let tokenEndpoint = "\(authBaseUrl)/token"
        guard let url = URL(string: tokenEndpoint) else {
            os_log("Error, Cannot create URL.", log: AuthClient.logTag, type: .error)
            return
        }
        
        var credentials: String?
        
        do {
            let credentialsDictionary: [String: String] = ["clientId": username, "clientSecret": password]
            let credentialsJSON = try JSONSerialization.data(withJSONObject: credentialsDictionary, options: [])
            credentials = String(data: credentialsJSON, encoding: String.Encoding.utf8)
        } catch {
            os_log("Error, Failed to Create Credentials JSON.", log: AuthClient.logTag, type: .error)
            return
        }
        
        APIRequest.post(withURL: url, andJson: credentials ?? "", fromController: nil, authRequired: false) {
            (json) -> Void in
            
            if let authResult: AuthResult = Mapper<AuthResult>().map(JSONString: json ?? "") {
                os_log("%@", log: AuthClient.logTag, type: .debug, authResult.description)
                
                OperationQueue.main.addOperation {
                    completion(authResult)
                }
            } else {
                os_log("User Conversion Failed.", log: AuthClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(AuthResult())
                }
            }
        }
    }
}
