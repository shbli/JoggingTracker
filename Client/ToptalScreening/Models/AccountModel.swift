//
//  AccountModel.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-05.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

var UserAccountModel: AccountModel?

class AccountModel : Decodable {
    var id: Int?
    var username: String?
    var password: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var groups: [Int]?
    var token: String?
}
