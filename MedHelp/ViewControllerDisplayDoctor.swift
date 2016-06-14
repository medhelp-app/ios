//
//  ViewControllerDisplayDoctor.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/31/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ViewControllerDisplayDoctor: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var doctorItem = DoctorItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.image = doctorItem.image
    }
    
    override func viewWillAppear(animated: Bool) {
        ImageCircle.styleCircleForImage(self.profileImage)
    }
}