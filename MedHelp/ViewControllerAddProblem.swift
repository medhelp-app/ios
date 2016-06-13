//
//  ViewControllerAddProblem.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/12/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ViewControllerAddProblem: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var width : CGFloat = 0
    var height : CGFloat = 0

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyPartLabel: UILabel!
    @IBOutlet weak var problemTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var severitySelector: UISegmentedControl!
    
    var selectedItem = ""
    var dateStamp = NSDate()
    let dateFormatter = NSDateFormatter()
    
    var controller : ViewControllerPatientBody = ViewControllerPatientBody()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.dateFormatter.dateStyle = .ShortStyle
        
        self.dateLabel.text = self.dateFormatter.stringFromDate(NSDate())
        
        self.preferredContentSize = CGSizeMake(self.width, self.height);
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dropdown" {
            let vc = segue.destinationViewController
            
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
            }
            
            let destination = vc as! ViewControllerDropdown
            destination.items = Array(ProblemsHelper.bodyPart.keys)
            destination.controller = self
        } else if segue.identifier == "datePicker" {
            let vc = segue.destinationViewController
            
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
            }
            
            let destination = vc as! ViewControllerDatePicker
            destination.controller = self
            destination.dateStamp = self.dateStamp

        }
    }
    

    @IBAction func openDropdown(sender: AnyObject) {
        self.performSegueWithIdentifier("dropdown", sender: self)
    }
    
    @IBAction func openDatePicker(sender: AnyObject) {
        self.performSegueWithIdentifier("datePicker", sender: self)
    }
    
    @IBAction func addProblem(sender: AnyObject) {
        
        let part = self.bodyPartLabel.text!
        let problemType = self.problemTextField.text!
        let description = self.descriptionTextField.text!
        let severity = ProblemsHelper.severityLevels[self.severitySelector.selectedSegmentIndex]
        
        if problemType.isEmpty || description.isEmpty {
            let alertController = UIAlertController(title: "Error", message:
                "Por favor, preencha todos os campos", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.POST, URLHelper.addPatientBodyPartProblem(), headers: headers, parameters: ["part" : ProblemsHelper.bodyPart[part]!, "problem": problemType, "description": description, "severity": severity, "occurredDate": self.dateStamp])
            .responseJSON { response in

                if let JSON = response.result.value {
                    print(JSON)
                    self.controller.loadBodyInfo()
                    self.dismissViewControllerAnimated(false, completion: nil);
                }
        }
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil);
    }    
}