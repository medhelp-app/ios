//
//  ImageCircle.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/14/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

class ImageCircle {
    
    static func styleCircleForImage(image:UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2.0
        image.clipsToBounds = true
        image.userInteractionEnabled = true
    }
}