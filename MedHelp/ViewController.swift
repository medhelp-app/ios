//
//  ViewController.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 4/9/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var LoginField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var DisplayMessage: UILabel!
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    
    var token : String = ""
    var userType : String = ""
    var id : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func displayAlert(message: String) {
        DisplayMessage.text = "*" + message
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mainScreen" {
            if self.userType == "0" {
                if let destination = segue.destinationViewController as? ViewControllerPatientProfile {
                    destination.token = self.token
                    destination.userType = self.userType
                    destination.id = self.id
                }
            } else {
                if let destination = segue.destinationViewController as? ViewControllerDoctorProfile {
                    destination.token = self.token
                    destination.userType = self.userType
                    destination.id = self.id
                }
            }
        }
    }
    
    // MARK: Actions
    @IBAction func Login(sender: UIButton) {
        
        let login = LoginField.text!
        let password = PasswordField.text!
        
        if (login == "patient" && password == "password") {
            self.performSegueWithIdentifier("patientScreen", sender: self)
            return
        }
        if (login == "doctor" && password == "password") {
            self.performSegueWithIdentifier("doctorScreen", sender: self)
            return
        }
        
        if login.isEmpty || password.isEmpty {
            // display empty field alert
            
            displayAlert("Todos os campos devem ser preenchidos")
            
            return
            
        } else if !Validator.validateEmail(login) {
            // display email not valid
            
            displayAlert("Email invalido")
            
            return
            
        } else {
            self.Spinner.startAnimating()
            Alamofire.request(.POST, "http://192.168.0.6:4000/api/users/login", parameters: ["email":login, "password":password]).responseJSON(completionHandler: { (response) -> Void in
                self.Spinner.stopAnimating()
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        self.displayAlert("E-mail ou senha inválidos")
                    } else {
                        
                        print ("loging in")
                        let user = dict!["user"]  as? NSDictionary
                        
                        self.token = dict!["token"] as! String
                        self.userType = user!["userType"] as! String
                        print (self.userType )
                        self.id = user!["_id"] as! String
                        
                        if (self.userType == "0") {
                            self.performSegueWithIdentifier("patientScreen", sender: self)
                        } else {
                            self.performSegueWithIdentifier("doctorScreen", sender: self)
                        }
                    }
                    
                } else {
                    self.displayAlert("A aplicação não conseguiu acessar o servidor")
                }
            })
        }
    }
}

