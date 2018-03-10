//
//  RestUtils.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-05.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

class RestUtils {
    //used for operations that does not require a token
    static func postRest(url: String, httpBodyDict: [String: Any], completionHandler: @escaping (Data?, URLResponse?, String) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBodyData: Data
        do {
            httpBodyData = try JSONSerialization.data(withJSONObject: httpBodyDict, options: [])
            request.httpBody = httpBodyData
            print("URL " + url)
            print("Request body:")
            print(String(data: httpBodyData, encoding: .utf8) ?? "Unable to convert data to string")
        } catch {
            print("Error: cannot create JSON from httpBodyDict")
            return
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            var errorString: String
            if (error != nil) {
                errorString = error!.localizedDescription
            } else {
                print("Response body:")
                let responseBody: String = String(data: data!, encoding: .utf8) ?? "Unable to convert data to string"
                print(responseBody)
                errorString = ErrorHandlingUtility.handleRestAPIError(responseBody: responseBody)
            }
            completionHandler(data, response, errorString)
        })
        task.resume()
    }
    
    static func postRest(url: String, token: String, httpBodyDict: [String: Any], completionHandler: @escaping (Data?, URLResponse?, String) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT " + token, forHTTPHeaderField: "Authorization")
        
        let httpBodyData: Data
        do {
            httpBodyData = try JSONSerialization.data(withJSONObject: httpBodyDict, options: [])
            request.httpBody = httpBodyData
            print("URL " + url)
            print("Request body:")
            print(String(data: httpBodyData, encoding: .utf8) ?? "Unable to convert data to string")
        } catch {
            print("Error: cannot create JSON from httpBodyDict")
            return
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            var errorString: String
            if (error != nil) {
                errorString = error!.localizedDescription
            } else {
                print("Response body:")
                let responseBody: String = String(data: data!, encoding: .utf8) ?? "Unable to convert data to string"
                print(responseBody)
                errorString = ErrorHandlingUtility.handleRestAPIError(responseBody: responseBody)
            }
            completionHandler(data, response, errorString)
        })
        task.resume()
    }

    static func putRest(url: String, token: String, httpBodyDict: [String: Any], completionHandler: @escaping (Data?, URLResponse?, String) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT " + token, forHTTPHeaderField: "Authorization")
        
        let httpBodyData: Data
        do {
            httpBodyData = try JSONSerialization.data(withJSONObject: httpBodyDict, options: [])
            request.httpBody = httpBodyData
            print("URL " + url)
            print("Request body:")
            print(String(data: httpBodyData, encoding: .utf8) ?? "Unable to convert data to string")
        } catch {
            print("Error: cannot create JSON from httpBodyDict")
            return
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            var errorString: String
            if (error != nil) {
                errorString = error!.localizedDescription
            } else {
                print("Response body:")
                let responseBody: String = String(data: data!, encoding: .utf8) ?? "Unable to convert data to string"
                print(responseBody)
                errorString = ErrorHandlingUtility.handleRestAPIError(responseBody: responseBody)
            }
            completionHandler(data, response, errorString)
        })
        task.resume()
    }

    static func getRest(url: String, token: String, completionHandler: @escaping (Data?, URLResponse?, String) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT " + token, forHTTPHeaderField: "Authorization")
        
        print("URL " + url)
        print("Request is get:")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            var errorString: String
            if (error != nil) {
                errorString = error!.localizedDescription
            } else {
                print("Response body:")
                let responseBody: String = String(data: data!, encoding: .utf8) ?? "Unable to convert data to string"
                print(responseBody)
                errorString = ErrorHandlingUtility.handleRestAPIError(responseBody: responseBody)
            }
            completionHandler(data, response, errorString)
        })
        task.resume()
    }

    static func deleteRest(url: String, token: String, completionHandler: @escaping (Data?, URLResponse?, String) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT " + token, forHTTPHeaderField: "Authorization")
        
        print("URL " + url)
        print("Request is get:")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            var errorString: String
            if (error != nil) {
                errorString = error!.localizedDescription
            } else {
                print("Response body:")
                let responseBody: String = String(data: data!, encoding: .utf8) ?? "Unable to convert data to string"
                print(responseBody)
                errorString = ErrorHandlingUtility.handleRestAPIError(responseBody: responseBody)
            }
            completionHandler(data, response, errorString)
        })
        task.resume()
    }
}
