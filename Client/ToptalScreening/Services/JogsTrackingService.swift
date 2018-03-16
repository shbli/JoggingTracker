//
//  JogsTrackingService.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-06.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

let SharedJogTrackingService = JogTrackingService()

class JogTrackingService {
    
    /*
     {
     "id": 3,
     "author": 1,
     "notes": "This is my second note updated",
     "activity_start_time": "2018-03-01T12:00:00Z",
     "distance": 1000,
     "time": 60,
     "created": "2018-03-01T12:00:00Z",
     "modified": "2018-03-01T12:00:00Z"
     }
     */
    
    //get all jog records
    func getJogRecords(onSuccess: @escaping (_ jogs : [Jog]) -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "jogs/"
        
        RestUtils.getRest(url: url, token: UserAccountModel!.token!, completionHandler: {data, response, error -> Void in
            if(error != "") {
                onError(error)
            } else {
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                
                let decoder: JSONDecoder =  JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                //var jogs = [Jog]()
                guard let jogs: [Jog] = try? decoder.decode([Jog].self, from: data) else {
                    print("Error: Couldn't decode data into [Jog]Model")
                    return
                }
                
                onSuccess(jogs)
            }
        })
    }

    //create a new jog record added by the user, distance in meters, time in minutes
    func createJogRecord(author: Int, notes: String, activity_start_time: Date, distance: Int, time: Int, created: Date, modified: Date, onSuccess: @escaping (_ jog: Jog) -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "jogs/"
        
        let formatter = ISO8601DateFormatter()
        
        let httpBodyDict: [String: Any] = ["author": author, "notes": notes, "activity_start_time": formatter.string(from: activity_start_time),
                                           "distance": distance, "time": time, "created": formatter.string(from: created), "modified": formatter.string(from: modified)]
        
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
                
                let decoder: JSONDecoder =  JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                guard let jog = try? decoder.decode(Jog.self, from: data) else {
                    print("Error: Couldn't decode data into JogModel")
                    return
                }
                
                onSuccess(jog)
            }
        })
    }
    
    //update a new jog record added by the user, distance in meters, time in minutes
    func updateJogRecord(id: Int, author: Int, notes: String, activity_start_time: Date, distance: Int, time: Int, created: Date, modified: Date, onSuccess: @escaping (_ jog: Jog) -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let url = APIBaseURL + "jogs/" + String(id) + "/"
        
        let formatter = ISO8601DateFormatter()
        
        let httpBodyDict: [String: Any] = ["author": author, "notes": notes, "activity_start_time": formatter.string(from: activity_start_time),
                                           "distance": distance, "time": time, "created": formatter.string(from: created), "modified": formatter.string(from: modified)]
        
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
                
                let decoder: JSONDecoder =  JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                guard let jog = try? decoder.decode(Jog.self, from: data) else {
                    print("Error: Couldn't decode data into JogModel")
                    return
                }
                
                onSuccess(jog)
            }
        })
    }


    //delete a jog record added by the user, distance in meters, time in minutes
    func deleteJogRecord(id: Int, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let url = APIBaseURL + "jogs/" + String(id) + "/"
        
        
        RestUtils.deleteRest(url: url, token: UserAccountModel!.token!, completionHandler: {data, response, error -> Void in
            if(error != "") {
                onError(error)
            } else {
                onSuccess()
            }
        })
    }
    
    //get weekly report for the jogs along with average time and distance for each week
    func getJogWeeklyReport(onSuccess: @escaping (_ jogWeeklyReport : [JogWeeklyReport]) -> Void, onError: @escaping (_ error: String) -> Void) {
        let url = APIBaseURL + "weekly-report/"
        
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
                
                guard let jogWeeklyReport: [JogWeeklyReport] = try? decoder.decode([JogWeeklyReport].self, from: data) else {
                    print("Error: Couldn't decode data into [Jog]Model")
                    return
                }
                
                onSuccess(jogWeeklyReport)
            }
        })
    }

}

