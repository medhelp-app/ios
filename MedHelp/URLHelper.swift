//
//  URLHelper.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/12/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation

class URLHelper {
    
    static func addPatientBodyPartProblem() -> String {
        return "https://medhelp-app.herokuapp.com/api/patients/\(LoginInfo.id)/bodyparts"
    }
    
    static func getHeader() -> NSDictionary {
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        return headers
    }
}