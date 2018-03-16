//
//  Jog.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-03.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class Jog: Decodable {
    var id: Int?
    var author: Int?
    var notes: String?
    var activity_start_time: Date?
    var distance: Int?
    var time: Int?
    var created: Date?
    var modified: Date?
    
    //newest appear first
    static func sortComparator(arg1: Jog, arg2: Jog) -> Bool {
        return arg1.activity_start_time! > arg2.activity_start_time!
    }
}
