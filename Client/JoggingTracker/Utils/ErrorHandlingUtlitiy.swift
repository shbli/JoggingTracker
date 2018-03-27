//
//  ErrorHandlingUtlitiy.swift
//  JoggingTracker
//
//  Created by Shbli on 2018-03-10.
//  Copyright © 2018 Shbli. All rights reserved.
//

import Foundation

class ErrorHandlingUtility {
    static func handleRestAPIError(responseBody: String) -> String {
        if (responseBody.contains("You do not have permission to perform this action.")) {
            return "You do not have permission to perform this action."
        }
        if (responseBody.contains("Unable to log in with provided credentials.")) {
            return "Unable to log in with provided credentials!"
        }
        if (responseBody.contains("OperationalError")) {
            return "Server Error"
        }
        return ""
    }
}
