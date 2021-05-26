//
//  LogFeedStubs.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

struct LogFeedStubs {
    let pageOne = """
        {
            "logs": [
                {
                  "comments": [],
                  "date": "2021-05-25",
                  "description": "Had to take three weeks off, but happy to be healthy and running again.",
                  "distance": 5.37,
                  "feel": 6,
                  "first": "Andrew",
                  "last": "Jarombek",
                  "location": "New York, NY",
                  "log_id": 1,
                  "metric": "miles",
                  "miles": 5.02,
                  "name": "Central Park Trails",
                  "pace": "0:06:54",
                  "time": "0:37:03",
                  "type": "run",
                  "username": "andy"
                }
              ],
              "next": "/v2/log_feed/all/all/25/25",
              "pages": 2,
              "prev": null,
              "self": "/v2/log_feed/all/all/25/25"
        }
    """
    
    var pageOneData: Data {
        get {
            return pageOne.data(using: .utf8)!
        }
    }
}
