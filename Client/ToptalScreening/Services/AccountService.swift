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
    
    //this is the login method, used to get the the account model of this user, and a token to be used in the rest of the application
    func authUser(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "token-auth/"
        let httpBodyDict: [String: Any] = ["username": username, "password": password]
        RestUtils.postRest(url: url, httpBodyDict: httpBodyDict, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                print("Error")
                print(String(describing: error))
                onError(String(describing: error))
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
    
    //create user method, used to create users
    func createUser(username: String, password: String, first_name: String, last_name: String, email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "users/"
        let httpBodyDict: [String: Any] = ["username": username, "password": password, "email": email, "first_name": first_name, "last_name": last_name]
        RestUtils.postRest(url: url, httpBodyDict: httpBodyDict, completionHandler: {data, response, error -> Void in            
            if(error != nil) {
                print("Error")
                print(String(describing: error))
                onError(String(describing: error))
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
                onSuccess()
            }
        })
    }
}
