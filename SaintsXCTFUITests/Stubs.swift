//
//  Stubs.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import Swifter

class Stubs {
    let server = HttpServer()
    
    func stubRequest(path: String, jsonData: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return
        }
        
        let response: ((HttpRequest) -> HttpResponse) = { _ in
            .ok(.json(json as AnyObject))
        }
        
        server.get[path] = response
    }
}
