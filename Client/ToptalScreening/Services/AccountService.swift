//
//  AccountService.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-05.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

let SharedAccountService = AccountService()

class AccountService {
    
    /*
     {
         "id": 1,
         "username": "shbli",
         "first_name": "",
         "last_name": "",
         "email": "info@shbli.com",
         "groups": [1,3]
     }
     */
    //this is the login method, used to get the the account model of this user, and a token to be used in the rest of the application
    func authUser(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "token-auth/"
        let httpBodyDict: [String: Any] = ["username": username, "password": password]
        RestUtils.postRest(url: url, httpBodyDict: httpBodyDict, completionHandler: {data, response, error -> Void in
            
            if(error != "") {
                onError(error)
            } else {
                print("Response body:")
                print(String(data: data!, encoding: .utf8) ?? "Unable to convert data to string")
                
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                
                guard let accountModel = try? JSONDecoder().decode(AccountModel.self, from: data) else {
                    print("Error: Couldn't decode data into AccountModel")
                    return
                }
                
                UserAccountModel = accountModel
                
                print("Account model username " + UserAccountModel!.username!)
                print("Account model token " + UserAccountModel!.token!)
                print("Account model group count " + String(UserAccountModel!.groups!.count))
                for group in UserAccountModel!.groups! {
                    print("Account model group item found " + String(group))
                }

                onSuccess()
            }
        })
    }
    
    func createUser(username: String, password: String, first_name: String, last_name: String, email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "users/"
        let httpBodyDict: [String: Any] = ["username": username, "password": password, "email": email, "first_name": first_name, "last_name": last_name]
        RestUtils.postRest(url: url, httpBodyDict: httpBodyDict, completionHandler: {data, response, error -> Void in
            if(error != "") {
                onError(error)
            } else {
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                
                guard let accountModel = try? JSONDecoder().decode(AccountModel.self, from: data) else {
                    print("Error: Couldn't decode data into AccountModel")
                    return
                }
                
                UserAccountModel = accountModel
                onSuccess()
            }
        })
    }

    //MARK: Admin only APIs
    func adminCreateUser(username: String, password: String, first_name: String, last_name: String, email: String, groups: [Int], onSuccess: @escaping (_ accountModel: AccountModel) -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "users/"
        let httpBodyDict: [String: Any] = ["username": username, "password": password, "email": email, "first_name": first_name, "last_name": last_name, "groups": groups]
        RestUtils.postRest(url: url, token: UserAccountModel!.token!, httpBodyDict: httpBodyDict, completionHandler: {data, response, error -> Void in
            if(error != "") {
                onError(error)
            } else {
                print("Response body:")
                print(String(data: data!, encoding: .utf8) ?? "Unable to convert data to string")
                
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                
                guard let accountModel = try? JSONDecoder().decode(AccountModel.self, from: data) else {
                    print("Error: Couldn't decode data into AccountModel")
                    return
                }
                
                onSuccess(accountModel)
            }
        })
    }

    func adminUpdateUser(id: Int, username: String, password: String, first_name: String, last_name: String, email: String, groups: [Int], onSuccess: @escaping (_ accountModel: AccountModel) -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "users/" + String(id) + "/"
        let httpBodyDict: [String: Any] = ["username": username, "password": password, "email": email, "first_name": first_name, "last_name": last_name, "groups": groups]
        RestUtils.putRest(url: url, token: UserAccountModel!.token!, httpBodyDict: httpBodyDict, completionHandler: {data, response, error -> Void in
            if(error != "") {
                onError(error)
            } else {
                print("Response body:")
                print(String(data: data!, encoding: .utf8) ?? "Unable to convert data to string")
                
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                
                guard let accountModel = try? JSONDecoder().decode(AccountModel.self, from: data) else {
                    print("Error: Couldn't decode data into AccountModel")
                    return
                }
                
                onSuccess(accountModel)
            }
        })
    }
    
    //delete a user record added by the user, distance in meters, time in minutes
    func admindDleteUserRecord(id: Int, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let url = APIBaseURL + "users/" + String(id) + "/"
        
        
        RestUtils.deleteRest(url: url, token: UserAccountModel!.token!, completionHandler: {data, response, error -> Void in
            if(error != "") {
                onError(error)
            } else {
                print("Response body:")
                print(String(data: data!, encoding: .utf8) ?? "Unable to convert data to string")
                
                onSuccess()
            }
        })
    }
    
    //get all user accounts, only can be run by an admin or a user manager, otherwise will return an empty list
    func adminGetAllUsers(onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "users/"
        
        RestUtils.getRest(url: url, token: UserAccountModel!.token!, completionHandler: {data, response, error -> Void in
            if(error != "") {
                onError(error)
            } else {
                print("Response body:")
                print(String(data: data!, encoding: .utf8) ?? "Unable to convert data to string")
                
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                
                let decoder: JSONDecoder =  JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                //var jogs = [Jog]()
                guard let allUsers: [AccountModel] = try? decoder.decode([AccountModel].self, from: data) else {
                    print("Error: Couldn't decode data into [Jog]Model")
                    return
                }
                
                AllUsersAccounts.removeAll()
                AllUsersAccounts.append(contentsOf: allUsers)
                print("All users count is " + String(AllUsersAccounts.count))
                onSuccess()
            }
        })
    }
}
