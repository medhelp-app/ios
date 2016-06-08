//
//  ImageEncoder.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/8/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

class ImageEncoder {
    
    static func encoder(img : UIImage) -> String {
        
        let imageData : NSData = UIImagePNGRepresentation(img)!
               
        return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}