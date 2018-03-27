//
//  JogWeeklyReport.swift
//  JoggingTracker
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
    var avg_distance: Double?
    var avg_time: Double?
    
    static func sortComparator(arg1: JogWeeklyReport, arg2: JogWeeklyReport) -> Bool {
        if (arg1.year! == arg1.year!) {
            //compare the weeks
            return arg1.week! > arg2.week!
        }
        return arg1.year! > arg2.year!
    }
}
