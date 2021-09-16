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

class Stubs {
    let server = HttpServer()
    
    func stubRequest(path: String, jsonData: Data, verb: StubHttpVerb = .get) {
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return
        }
        
        let response: ((HttpRequest) -> HttpResponse) = { _ in
            .ok(.json(json as AnyObject))
        }
        
        if verb == .get {
            server.get[path] = response
        } else if verb == .post {
            server.post[path] = response
        } else if verb == .put {
            server.put[path] = response
        } else if verb == .delete {
            server.delete[path] = response
        }
    }
}
