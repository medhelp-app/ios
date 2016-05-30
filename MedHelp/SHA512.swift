//
//  SHA512.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/28/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import CryptoSwift

class SHA512 {
    
    static func sha512(password : String) -> String {
        return password.sha512()
    }
}