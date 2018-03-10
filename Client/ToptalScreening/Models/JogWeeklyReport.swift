//
//  JogWeeklyReport.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-09.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

/*
 
 {
 "week": 9,
 "year": 2018,
 "avg_distance": 226.0,
 "avg_time": 10.0
 }
 
 */

class JogWeeklyReport: Decodable {
    var week: Int?
    var year: Int?
    var avg_distance: Int?
    var avg_time: Int?
}
