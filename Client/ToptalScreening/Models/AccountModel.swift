//
//  AccountModel.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-05.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

var AllUsersAccounts = [AccountModel]()
var UserAccountModel: AccountModel?

enum AccountType: Int {
    case None = 0
    case Admin = 1
    case UserManager = 2
    case RegularUser = 3
    case RecordsAdmin = 4
}

class AccountModel : Decodable {
    var id: Int?
    var username: String?
    var password: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var groups: [Int]?
    var token: String?
    
    func accountType() -> AccountType {
        if (groups != nil) {
            if (groups?.contains(AccountType.Admin.rawValue))! {
                return AccountType.Admin;
            }

            if (groups?.contains(AccountType.UserManager.rawValue))! {
                return AccountType.UserManager;
            }

            if (groups?.contains(AccountType.RecordsAdmin.rawValue))! {
                return AccountType.RecordsAdmin;
            }

            if (groups?.contains(AccountType.RegularUser.rawValue))! {
                return AccountType.RegularUser;
            }
        }
        return AccountType.None;
    }
    
    func copy() -> AccountModel {
        let accountModelCopy: AccountModel = AccountModel()
        accountModelCopy.id = self.id
        accountModelCopy.username = self.username
        accountModelCopy.password = self.password
        accountModelCopy.first_name = self.first_name
        accountModelCopy.last_name = self.last_name
        accountModelCopy.email = self.email
        accountModelCopy.groups = self.groups
        accountModelCopy.token = self.token
        return accountModelCopy
    }
}
