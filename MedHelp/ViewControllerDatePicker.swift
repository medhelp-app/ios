//
//  ViewControllerDatePicker.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/13/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerDatePicker: UIViewController {
    
    var width : CGFloat = 280
    var height : CGFloat = 200
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var dateStamp = NSDate()
    
    var controller : ViewControllerAddProblem = ViewControllerAddProblem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.date = self.dateStamp
        self.datePicker.maximumDate = NSDate()
        self.preferredContentSize = CGSizeMake(self.width, self.height);
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.controller.dateStamp = self.datePicker.date
        self.controller.dateLabel.text = self.controller.dateFormatter.stringFromDate(self.datePicker.date)
    }
}