//
//  DisplayMessages.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/28/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit


class DisplayMessages {
    
    static func displayAlert(message : String, textField : UILabel) {
        textField.text = "*" + message
    }
}