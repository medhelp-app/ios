//
//  ImageDecoder.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/8/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

class ImageDecoder {
    
    static func decode(img : String) -> UIImage {
    
        let encodedImageData = img
        let imageData = NSData(base64EncodedString: encodedImageData, options: .IgnoreUnknownCharacters)
    
        return UIImage(data: imageData!)!
    }
}