//
//  Problem.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/12/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation

class Problem {
    
    var id : String = ""
    var description : String = ""
    var problem : String = ""
    var severity : String = ""
    
    init(id : String, description : String, problem : String, severity : String) {
        self.id = id
        self.description = description
        self.problem = problem
        self.severity = severity
    }
}