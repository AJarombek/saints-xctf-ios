//
//  RangeViewStubs.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 6/4/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

struct RangeViewStubs {
    let userAndyCurrentMonth = """
        {
           "range_view": [
              {
                 "date":"Mon, 31 May 2021 00:00:00 GMT",
                 "feel":7,
                 "miles":7.28000020980835
              },
              {
                 "date":"Tue, 01 Jun 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":2.930000066757202
              },
              {
                 "date":"Wed, 02 Jun 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":7.039999961853027
              },
              {
                 "date":"Wed, 03 Jun 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":4.549999923706055
              },
              {
                 "date":"Wed, 04 Jun 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":4.489999828338623
              }
           ],
           "self":"/v2/range_view/users/andy/r/2021-05-31/2021-07-11"
        }
    """
    
    let userAndyPreviousMonth = """
        {
           "range_view": [
              {
                 "date":"Mon, 26 Apr 2021 00:00:00 GMT",
                 "feel":5,
                 "miles":2.869999885559082
              },
              {
                 "date":"Tue, 27 Apr 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":6.570000171661377
              },
              {
                 "date":"Wed, 28 Apr 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":5.869999885559082
              },
              {
                 "date":"Thu, 29 Apr 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":11.759999752044678
              },
              {
                 "date":"Fri, 30 Apr 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":10.539999961853027
              },
              {
                 "date":"Sat, 01 May 2021 00:00:00 GMT",
                 "feel":4,
                 "miles":5.829999923706055
              },
              {
                 "date":"Thu, 06 May 2021 00:00:00 GMT",
                 "feel":1,
                 "miles":2.0899999141693115
              },
              {
                 "date":"Fri, 21 May 2021 00:00:00 GMT",
                 "feel":4,
                 "miles":2.180000066757202
              },
              {
                 "date":"Sat, 22 May 2021 00:00:00 GMT",
                 "feel":5,
                 "miles":2.930000066757202
              },
              {
                 "date":"Sun, 23 May 2021 00:00:00 GMT",
                 "feel":5,
                 "miles":5.369999885559082
              },
              {
                 "date":"Mon, 24 May 2021 00:00:00 GMT",
                 "feel":5,
                 "miles":3.25
              },
              {
                 "date":"Wed, 26 May 2021 00:00:00 GMT",
                 "feel":5,
                 "miles":5.349999904632568
              },
              {
                 "date":"Thu, 27 May 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":4.510000228881836
              },
              {
                 "date":"Fri, 28 May 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":3.819999933242798
              },
              {
                 "date":"Sat, 29 May 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":8.34000015258789
              },
              {
                 "date":"Sun, 30 May 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":4.429999828338623
              },
              {
                 "date":"Mon, 31 May 2021 00:00:00 GMT",
                 "feel":7,
                 "miles":7.28000020980835
              },
              {
                 "date":"Tue, 01 Jun 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":2.930000066757202
              },
              {
                 "date":"Wed, 02 Jun 2021 00:00:00 GMT",
                 "feel":6,
                 "miles":7.039999961853027
              }
           ],
           "self":"/v2/range_view/users/andy/r/2021-04-26/2021-06-06"
        }
    """
    
    var userAndyCurrentMonthData: Data {
        get {
            return userAndyCurrentMonth.data(using: .utf8)!
        }
    }
    
    var userAndyPreviousMonthData: Data {
        get {
            return userAndyPreviousMonth.data(using: .utf8)!
        }
    }
}
