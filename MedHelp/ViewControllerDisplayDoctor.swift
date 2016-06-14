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
import Cosmos

class ViewControllerDisplayDoctor: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var averageRating: CosmosView!
    
    var doctorItem = DoctorItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.image = doctorItem.image
    }
    
    override func viewWillAppear(animated: Bool) {
        ImageCircle.styleCircleForImage(self.profileImage)
    }
}