//
//  RestUtils.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-05.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

class RestUtils {
    
    static func postRest(url: String, httpBodyDict: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
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
            completionHandler(data, response, error)
        })
        task.resume()
    }

}
