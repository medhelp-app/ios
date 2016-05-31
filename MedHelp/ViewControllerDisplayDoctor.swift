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
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print ("nome \(self.name)")
    }

}