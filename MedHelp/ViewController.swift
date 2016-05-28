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
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var displayMessage: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
    
    // MARK: Actions
    
    @IBAction func Login(sender: UIButton) {
        
        let login = loginField.text!
        let password = passwordField.text!
        
        if login.isEmpty || password.isEmpty {
            
            DisplayMessages.displayAlert("Todos os campos devem ser preenchidos", textField: displayMessage)
            
            return
            
        } else if !Validator.validateEmail(login) {
            
            DisplayMessages.displayAlert("Email invalido", textField: displayMessage)
            
            return
            
        } else {
            self.spinner.startAnimating()
            Alamofire.request(.POST, "https://medhelp-app.herokuapp.com/api/users/login", parameters: ["email":login, "password":password]).responseJSON(completionHandler: { (response) -> Void in
                self.spinner.stopAnimating()
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        DisplayMessages.displayAlert("E-mail ou senha inválidos", textField: self.displayMessage)
                    } else {
                        
                        print ("loging in")
                        let user = dict!["user"]  as? NSDictionary
                        
                        LoginInfo.token = dict!["token"] as! String
                        LoginInfo.id = user!["_id"] as! String
                        
                        if (user!["userType"] as! String == "0") {
                            self.performSegueWithIdentifier("patientScreen", sender: self)
                        } else {
                            self.performSegueWithIdentifier("doctorScreen", sender: self)
                        }
                    }
                    
                } else {
                    DisplayMessages.displayAlert("A aplicação não conseguiu acessar o servidor", textField: self.displayMessage)
                }
            })
        }
    }
}

