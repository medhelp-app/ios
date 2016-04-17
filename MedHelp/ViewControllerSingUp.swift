//
//  ViewControllerSingUp.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 4/16/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerSingUp: UIViewController {

    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var RePasswordTextField: UITextField!
    @IBOutlet weak var DisplayMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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

    @IBAction func signUP(sender: UIButton) {
        let name = NameTextField.text!
        let email = EmailTextField.text!
        let password = PasswordTextField.text!
        let rePassword = RePasswordTextField.text!
        
        if name.isEmpty || email.isEmpty || password.isEmpty || rePassword.isEmpty {
            displayAlert("Todos os campos devem ser preenchidos")
        } else if !Validator.validateEmail(email) {
            displayAlert("Email inválido")
        } else if !Validator.validatePassword(password) {
            displayAlert("Sua senha deve conter mais de 7 caracteres")
        } else if password != rePassword {
            displayAlert("As senhas devem ser iguais")
        } else {
            Alamofire.request(.POST, "http://192.168.0.8:4000/api/users/", parameters: ["name":name, "email":email, "password":password, "rePassword":rePassword]).responseJSON(completionHandler: { (response) -> Void in
                
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        self.displayAlert("Error: \(JSON["error"])")
                    } else {
                        self.performSegueWithIdentifier("mainScreenFromSignup", sender: self)
                    }
                    
                } else {
                    self.displayAlert("The application could not connect to the server")
                }
            })
        }
    }
    
}
