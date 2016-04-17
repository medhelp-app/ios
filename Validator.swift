//
//  Validator.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 4/17/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation

class Validator {
    
    static func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
}