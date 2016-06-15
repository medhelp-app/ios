//
//  RatingItem.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/15/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation

struct RatingItem {
    
    let comment : String
    let rating : Double
    
    init() {
        self.comment = ""
        self.rating = 0
    }
    
    init(comment : String, rating : Double) {
        self.comment = comment
        self.rating = rating
    }
}
