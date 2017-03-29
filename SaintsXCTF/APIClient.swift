//
//  APIClient.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

class APIClient {
    
    
    public static func userGetRequest(withUser username: String) {
        
        // Create the URL
        let userGetEndpoint = "https://www.saintsxctf.com/api/api.php/users/\(username)"
        guard let url = URL(string: userGetEndpoint) else {
            print("Error: Cannot create URL")
            return
        }
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (data) -> Void in
            
            do {
                guard let user = try JSONSerialization.jsonObject(with: responseData, options: [])
            }
        }
    }
}
