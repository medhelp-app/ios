//
//  ViewControllerPatientBody.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/11/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ViewControllerPatientBody: UIViewController, UIPopoverPresentationControllerDelegate {
   
    
    @IBOutlet weak var body: UIView!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var chestImage: UIImageView!
    @IBOutlet weak var stomachImage: UIImageView!
    @IBOutlet weak var leftArm: UIImageView!
    @IBOutlet weak var rightArm: UIImageView!
    @IBOutlet weak var leftLeg: UIImageView!
    @IBOutlet weak var rightLeg: UIImageView!
    
    var screenSize : CGSize = CGSize()
    var partSelected : String = ""
    
    func mostSevere(part: [Problem]) -> String {
        if (part.count == 0) {
            return "grey"
        }
        
        var severity = 0
        
        for p in part {
            var index = ProblemsHelper.findSeverityLevel(p.severity)
            if severity < index {
                severity = index
            }
            
        }
        return ProblemsHelper.severityLevels[severity]
    }
    
    func loadBody() {
        for key in Array(Patient.bodyProblems.problems.keys) {
            var severity = self.mostSevere(Patient.bodyProblems.problems[key]!)
            switch key {
            case ProblemsHelper.HEAD:
                self.headImage.image = UIImage(named: severity + key)
            case ProblemsHelper.CHEST:
                self.chestImage.image = UIImage(named: severity + key)
            case ProblemsHelper.STOMACH:
                self.stomachImage.image = UIImage(named: severity + key)
            case ProblemsHelper.LEFTARM:
                self.leftArm.image = UIImage(named: severity + key)
            case ProblemsHelper.LEFTLEG:
                self.leftLeg.image = UIImage(named: severity + key)
            case ProblemsHelper.RIGHTARM:
                self.rightArm.image = UIImage(named: severity + key)
            case ProblemsHelper.RIGHTLEG:
                self.rightLeg.image = UIImage(named: severity + key)
            default:
                continue
            }
        }
    }
    
    func loadBodyInfo() {
        
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.GET, "https://medhelp-app.herokuapp.com/api/patients/\(LoginInfo.id)/bodyparts", headers: headers)
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    Patient.bodyProblems.clean()
                    
                    let parts = JSON as? NSArray
                    
                    for part in parts! {
                        let dictPart = part as! NSDictionary
                        let partType = dictPart["part"] as! String
                        
                        let problems = dictPart["problems"] as? NSArray
                        
                        for problem in problems! {
                            let problemItem = problem as! NSDictionary
                            let id = problemItem["_id"] as! String
                            let description = problemItem["description"] as! String
                            let problem = problemItem["problem"] as! String
                            let severity = problemItem["severity"] as! String
                            
                            
                            let problemObj = Problem(id: id, description : description, problem : problem, severity : severity)
                            
                            Patient.bodyProblems.addProblem(problemObj, part: partType)
                        }
                    }
                    self.loadBody()
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenBounds = UIScreen.mainScreen().bounds
        let screenScale = UIScreen.mainScreen().scale
        
        self.screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
        
        loadBodyInfo()
    }
    
    //Mark: actions
  
    @IBAction func bodyTapped(sender: AnyObject) {
        print("touch")
    }
    
    func checkRange(location : CGPoint, x1 : CGFloat, x2 : CGFloat, y1 : CGFloat, y2 : CGFloat) -> Bool {
        
        if (location.x > x1 && location.x <= x2 && location.y > y1 && location.y <= y2) {
            return true
        }
        return false
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProblems" {
            let vc = segue.destinationViewController
            
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
            }
            
            let destination = vc as! ViewControllerProblemsPopUp
            
            destination.problemsList = Patient.bodyProblems.getProblemFromPart(self.partSelected) as! [String]
            destination.width = self.screenSize.width
            destination.height = self.screenSize.height / 3
        } else if segue.identifier == "addProblem" {
            let vc = segue.destinationViewController
            
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
            }
            
            let destination = vc as! ViewControllerAddProblem
            destination.width = self.screenSize.width
            destination.height = 300
            destination.controller = self
        }
    }
    
    func openProblem(problemType : String) {
        print (problemType)
        self.partSelected = problemType
        self.performSegueWithIdentifier("showProblems", sender: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInView(self.body)
        
        switch self.screenSize {
        case ScreenSizes.IPHONE4S:
            if (self.checkRange(location, x1: 85, x2: 140, y1: 0, y2: 60)) {
                openProblem(ProblemsHelper.HEAD)
            } else if (self.checkRange(location, x1: 73, x2: 153.5, y1: 60, y2: 110)) {
                openProblem(ProblemsHelper.CHEST)
            } else if (self.checkRange(location, x1: 73, x2: 153.5, y1: 110, y2: 175)) {
                openProblem(ProblemsHelper.STOMACH)
            } else if (self.checkRange(location, x1: 65, x2: 115, y1: 175, y2: 360)) {
                openProblem(ProblemsHelper.LEFTLEG)
            } else if (self.checkRange(location, x1: 115, x2: 160, y1: 175, y2: 360)) {
                openProblem(ProblemsHelper.RIGHTLEG)
            } else if (self.checkRange(location, x1: 0, x2: 73, y1: 70, y2: 215)) {
                openProblem(ProblemsHelper.LEFTARM)
            } else if (self.checkRange(location, x1: 153.5, x2: 225, y1: 70, y2: 215)) {
                openProblem(ProblemsHelper.RIGHTARM)
            }
        case ScreenSizes.IPHONE5:
            if (self.checkRange(location, x1: 85, x2: 140, y1: 0, y2: 70)) {
                openProblem(ProblemsHelper.HEAD)
            } else if (self.checkRange(location, x1: 73, x2: 153.5, y1: 70, y2: 140)) {
                openProblem(ProblemsHelper.CHEST)
            } else if (self.checkRange(location, x1: 73, x2: 153.5, y1: 140, y2: 215)) {
                openProblem(ProblemsHelper.STOMACH)
            } else if (self.checkRange(location, x1: 65, x2: 115, y1: 215, y2: 445)) {
                openProblem(ProblemsHelper.LEFTLEG)
            } else if (self.checkRange(location, x1: 115, x2: 160, y1: 215, y2: 445)) {
                openProblem(ProblemsHelper.RIGHTLEG)
            } else if (self.checkRange(location, x1: 0, x2: 73, y1: 78, y2: 270)) {
                openProblem(ProblemsHelper.LEFTARM)
            } else if (self.checkRange(location, x1: 153.5, x2: 225, y1: 78, y2: 270)) {
                openProblem(ProblemsHelper.RIGHTARM)
            }
        case ScreenSizes.IPHONE6:
            if (self.checkRange(location, x1: 105, x2: 175, y1: 0, y2: 85)) {
                openProblem(ProblemsHelper.HEAD)
            } else if (self.checkRange(location, x1: 90, x2: 190, y1: 85, y2: 170)) {
                openProblem(ProblemsHelper.CHEST)
            } else if (self.checkRange(location, x1: 90, x2: 190, y1: 170, y2: 265)) {
                openProblem(ProblemsHelper.STOMACH)
            } else if (self.checkRange(location, x1: 80, x2: 140, y1: 265, y2: 545)) {
                openProblem(ProblemsHelper.LEFTLEG)
            } else if (self.checkRange(location, x1: 140, x2: 200, y1: 265, y2: 545)) {
                openProblem(ProblemsHelper.RIGHTLEG)
            } else if (self.checkRange(location, x1: 0, x2: 90, y1: 95, y2: 330)) {
                openProblem(ProblemsHelper.LEFTARM)
            } else if (self.checkRange(location, x1: 190, x2: 280, y1: 95, y2: 330)) {
                openProblem(ProblemsHelper.RIGHTARM)
            }
        case ScreenSizes.IPHONE6PLUS:
            if (self.checkRange(location, x1: 115, x2: 192, y1: 0, y2: 95)) {
                openProblem(ProblemsHelper.HEAD)
            } else if (self.checkRange(location, x1: 100, x2: 210, y1: 95, y2: 190)) {
                openProblem(ProblemsHelper.CHEST)
            } else if (self.checkRange(location, x1: 100, x2: 210, y1: 190, y2: 295)) {
                openProblem(ProblemsHelper.STOMACH)
            } else if (self.checkRange(location, x1: 89, x2: 155, y1: 295, y2: 615)) {
                openProblem(ProblemsHelper.LEFTLEG)
            } else if (self.checkRange(location, x1: 155, x2: 220, y1: 295, y2: 615)) {
                openProblem(ProblemsHelper.RIGHTLEG)
            } else if (self.checkRange(location, x1: 0, x2: 100, y1: 105, y2: 370)) {
                openProblem(ProblemsHelper.LEFTARM)
            } else if (self.checkRange(location, x1: 210, x2: 310, y1: 105, y2: 370)) {
                openProblem(ProblemsHelper.RIGHTARM)
            }
        default:
            print ("couldn't reconize")
        }
    }
    
    @IBAction func addProblem(sender: AnyObject) {
        self.performSegueWithIdentifier("addProblem", sender: self)   
    }
    
}