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
    
    // MARK: Actions
    @IBAction func Login(sender: UIButton) {
        
        let login = LoginField.text!
        let password = PasswordField.text!
        
        if login.isEmpty || password.isEmpty {
            // display empty field alert
            
            displayAlert("Todos os campos devem ser preenchidos")
            
            return
            
        } else if !Validator.validateEmail(login) {
            // display email not valid
            
            displayAlert("Email invalido")
            
            return
            
        } else {
            Alamofire.request(.POST, "http://192.168.0.8:4000/api/users/login", parameters: ["email":login, "password":password]).responseJSON(completionHandler: { (response) -> Void in
                
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        self.displayAlert("E-mail ou senha inválidos")
                    } else {
                        
                        print ("loging in")
                        self.performSegueWithIdentifier("mainScreen", sender: self)
                    }
                    
                } else {
                    self.displayAlert("The application could not connect to the server")
                }
            })
        }
    }
}

