//
//  MedicoItem.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/27/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

struct DoctorItem {
    
    let id : String
    let name : String
    let specialty : String
    let email : String
    let image : UIImage
    
    init() {
        self.id = ""
        self.name = ""
        self.specialty = ""
        self.email = ""
        self.image = UIImage()
    }
    
    init(id : String, name : String, specialty : String, email : String, image : UIImage) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.email = email
        self.image = image
    }
}