//
//  PatientBody.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/12/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation

class PatientBody {
 
    var problems = ["head" : [Problem](), "chest" : [Problem](), "stomach" : [Problem](), "rightArm" : [Problem](), "leftArm" : [Problem](), "rightLeg" : [Problem](), "leftLeg" : [Problem]()]
    
    func addProblem(problem : Problem, part : String) {
        print(part)
        self.problems[part]! += [problem]
    }
    
    func getProblemFromPartObject(part: String) -> [Problem] {
        return self.problems[part]!
    }
    
    func getProblemFromPart(part : String) -> NSArray {
        var problemsString = [String]()
        print(self.problems[part]!)
        for p in self.problems[part]! {
            problemsString += [p.problem]
        }
        return problemsString
    }
    
    func clean() {
        self.problems = ["head" : [Problem](), "chest" : [Problem](), "stomach" : [Problem](), "rightArm" : [Problem](), "leftArm" : [Problem](), "rightLeg" : [Problem](), "leftLeg" : [Problem]()]
    }
}