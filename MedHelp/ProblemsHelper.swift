//
//  ProblemsHelper.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/12/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

class ProblemsHelper {
    
    static let HEAD = "head"
    static let CHEST = "chest"
    static let STOMACH = "stomach"
    static let LEFTARM = "leftArm"
    static let RIGHTARM = "rightArm"
    static let LEFTLEG = "leftLeg"
    static let RIGHTLEG = "rightLeg"
    
    static let bodyPart = ["Cabeça": HEAD, "Peito": CHEST, "Abdómem": STOMACH, "Braço esquerdo": LEFTARM, "Braço direito": RIGHTARM, "Perna esquerda": LEFTLEG, "Perna direita": RIGHTLEG]
    
    static let severityLevels = ["Low", "Medium", "High"]
    
    static func findSeverityLevel(severity : String) -> Int {
        for i in 0...2 {
            if severityLevels[i] == severity {
                return i
            }
        }
        return -1
    }
}