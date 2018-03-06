//
//  Jog.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-03.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class Jog {
    var label: String
    init? (label: String) {
        if label.isEmpty {
            return nil
        }
        self.label = label
    }
}
