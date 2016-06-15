//
//  ViewControllerRating.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/14/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Cosmos

class ViewControllerRating: UIViewController {
    
    var width : CGFloat = 400
    var height : CGFloat = 390
    
    @IBOutlet weak var ontime: CosmosView!
    @IBOutlet weak var attention: CosmosView!
    @IBOutlet weak var place: CosmosView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ontime.settings.fillMode = .Half
        self.attention.settings.fillMode = .Half
        self.place.settings.fillMode = .Half
        
        self.preferredContentSize = CGSizeMake(self.width, self.height);
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    
    @IBAction func save(sender: AnyObject) {
    }
}