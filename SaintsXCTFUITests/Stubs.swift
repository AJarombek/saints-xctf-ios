//
//  Stubs.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import Swifter

enum StubHttpVerb: String, CaseIterable, Identifiable {
    case get
    case post
    case put
    case delete
    
    var id: String {
        self.rawValue
    }
}

enum StubHttpStatus: String, CaseIterable, Identifiable {
    case ok
    case badRequest
    
    var id: String {
        self.rawValue
    }
}

class Stubs {
    let server = HttpServer()
    
    func stubRequest(path: String, jsonData: Data, verb: StubHttpVerb = .get, status: StubHttpStatus = .ok) {
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return
        }
        
        let response: ((HttpRequest) -> HttpResponse) = { _ in
            if status == .badRequest {
                return HttpResponse.badRequest(.json(json as AnyObject))
            } else {
                return HttpResponse.ok(.json(json as AnyObject))
            }
        }
        
        if verb == .post {
            server.post[path] = response
        } else if verb == .put {
            server.put[path] = response
        } else if verb == .delete {
            server.delete[path] = response
        } else {
            server.get[path] = response
        }
    }
}
