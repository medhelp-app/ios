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
    
    static func getDoctorsOpnion(id : String) -> String {
        return "https://medhelp-app.herokuapp.com/api/doctors/\(id)/opinions"
    }
    
    static func getDoctorsOpnionSummary(id : String) -> String {
        return "https://medhelp-app.herokuapp.com/api/doctors/\(id)/opinions/summary"
    }
    
    static func getDoctorInfo(id: String) -> String {
        return "https://medhelp-app.herokuapp.com/api/doctors/\(id)"
    }
    
    static func getHeader() -> [String:String] {
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        return headers
    }
}