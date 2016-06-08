//
//  ViewControllerDoctorEdit.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/27/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerDoctoEdit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var crmNumberTextField: UITextField!
    @IBOutlet weak var crmStateTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var displayMessage: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var name = ""
    var email = ""
    var crmNumber = ""
    var crmState = ""
    var street = ""
    var zipCode = ""
    var city = ""
    var state = ""
    var country = ""
    var phone = ""
    var image = ""
    
    func getDoctorInfo() {
        
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.GET, "https://medhelp-app.herokuapp.com/api/doctors/\(LoginInfo.id)", headers: headers)
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        print (keyExists)
                    } else {
                        self.name = (dict!["name"] as? String)!
                        self.email = (dict!["email"] as? String)!
                        self.street = (dict!["addressStreet"] as? String)!
                        self.zipCode = (dict!["zipCode"] as? String)!
                        self.city = (dict!["city"] as? String)!
                        self.state = (dict!["state"] as? String)!
                        self.country = (dict!["country"] as? String)!
                        self.phone = (dict!["phone"] as? String)!
                        self.crmNumber = (dict!["crm"] as? String)!
                        if (dict!["ufCrm"] != nil) {
                            self.crmState = (dict!["ufCrm"] as? String)!
                        }
                        self.fillFields()
                    }
                }
        }
        
        Alamofire.request(.GET, "https://medhelp-app.herokuapp.com/api/doctors/\(LoginInfo.id)/image", headers: headers)
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary

                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        print (keyExists)
                    } else {
                        let img = (dict!["profileImage"] as? String)!
                        if (img != "") {
                            print ("load new image")
                            self.profilePicture.image = ImageDecoder.decode(img)
                            self.image = img
                            print ("igual")
                            print(ImageEncoder.encoder(self.profilePicture.image!) == img)
                        }
                    }
                }
        }
    }
    
    func fillFields() {
        nameTextField.text = self.name
        emailTextField.text = self.email
        streetTextField.text = self.street
        zipCodeTextField.text = self.zipCode
        cityTextField.text = self.city
        stateTextField.text = self.state
        countryTextField.text = self.country
        phoneTextField.text = self.phone
        crmNumberTextField.text = self.crmNumber
        crmStateTextField.text = self.crmState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        getDoctorInfo()
        
        self.image = ImageEncoder.encoder(self.profilePicture.image!)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.styleCircleForImage(self.profilePicture)
    }
    
    func styleCircleForImage(image:UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2.0
        image.clipsToBounds = true
        image.userInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func save(sender: AnyObject) {
        let name = self.nameTextField.text!
        let email = self.emailTextField.text!
        let street = self.streetTextField.text!
        let zipCode = self.zipCodeTextField.text!
        let city = self.cityTextField.text!
        let state = self.stateTextField.text!
        let country = self.countryTextField.text!
        let phone = self.phoneTextField.text!
        let crmNumber = self.crmNumberTextField.text!
        let crmState = self.crmStateTextField.text!
        
        if (name.isEmpty || email.isEmpty) {
            DisplayMessages.displayAlert("O campo do nome e de email devem ser preenchidos", textField: self.displayMessage)
            return
        } else if (!Validator.validateEmail(email)) {
            DisplayMessages.displayAlert("Email inválido", textField: self.displayMessage)
            return
        } else {
            
            let headers = [
                "x-access-token": "\(LoginInfo.token)",
                "Accept": "application/json"
            ]
            
            let img = ImageEncoder.encoder(self.profilePicture.image!)
            
            if (image != img) {
                
                
               // print ("here is an image \(img)")
                
                print("is it heeere?   ")
                Alamofire.request(.PUT, "https://medhelp-app.herokuapp.com/api/doctors/\(LoginInfo.id)/image", headers: headers, parameters : ["profileImage" : img])
                    .responseJSON { response in
                        //debugPrint(response)
                        print (response)
                        if let JSON = response.result.value {
                            print("Whaat?" + (JSON as! String) as String)
                            let dict = JSON as? NSDictionary
                            
                            let keyExists = dict!["error"] != nil
                            
                            if keyExists {
                                print (keyExists)
                            } else {
                                
                            }
                        }
                }
            }
            
            
            Alamofire.request(.PUT, "https://medhelp-app.herokuapp.com/api/doctors/\(LoginInfo.id)", headers: headers, parameters : ["profileImage" : "", "name" : name,
                "email" : email, "addressStreet" : street, "addressNumber" : "", "zipCode" : zipCode, "city" : city,
                "state" : state, "country" : country, "phone" : phone, "crm" : crmNumber, "ufCrm" : crmState])
                .responseJSON { response in
                    //debugPrint(response)
                    if let JSON = response.result.value {
                        
                        let dict = JSON as? NSDictionary
                        
                        let keyExists = dict!["error"] != nil
                        
                        if keyExists {
                            DisplayMessages.displayAlert("\(keyExists)", textField: self.displayMessage)
                        } else {
                            self.performSegueWithIdentifier("doctorScreen", sender: self)
                        }
                    }
            }
        }
    }
    
    @IBAction func loadImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePicture.contentMode = .ScaleAspectFit
            self.profilePicture.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
