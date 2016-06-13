//
//  ViewControllerEditPatient.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/23/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerPatientEdit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
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
    var street = ""
    var zipCode = ""
    var city = ""
    var state = ""
    var country = ""
    var phone = ""
    var image = ""
    
    func getPatientInfo() {
        
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.GET, "https://medhelp-app.herokuapp.com/api/patients/\(LoginInfo.id)", headers: headers)
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        DisplayMessages.displayAlert("\(keyExists)", textField: self.displayMessage)
                    } else {
                        self.name = (dict!["name"] as? String)!
                        self.email = (dict!["email"] as? String)!
                        self.street = (dict!["addressStreet"] as? String)!
                        self.zipCode = (dict!["zipCode"] as? String)!
                        self.city = (dict!["city"] as? String)!
                        self.state = (dict!["state"] as? String)!
                        self.country = (dict!["country"] as? String)!
                        self.phone = (dict!["phone"] as? String)!
                        self.fillFields()
                    }
                }
        }
        
        Alamofire.request(.GET, "https://medhelp-app.herokuapp.com/api/patients/\(LoginInfo.id)/image", headers: headers)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        getPatientInfo()
        
        self.image = ImageEncoder.encoder(self.profilePicture.image!)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.styleCircleForImage(self.profilePicture)
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
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func styleCircleForImage(image:UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2.0
        image.clipsToBounds = true
        image.userInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
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
            
            Alamofire.request(.PUT, "https://medhelp-app.herokuapp.com/api/patients/\(LoginInfo.id)", headers: headers, parameters : ["profileImage" : "", "name" : name,
                "email" : email, "addressStreet" : street, "addressNumber" : "", "zipCode" : zipCode, "city" : city,
                "state" : state, "country" : country, "phone" : phone])
                .responseJSON { response in
                    //debugPrint(response)
                    if let JSON = response.result.value {
                        
                        let dict = JSON as? NSDictionary
                        
                        let keyExists = dict!["error"] != nil
                        
                        if keyExists {
                            DisplayMessages.displayAlert("\(keyExists)", textField: self.displayMessage)
                        } else {
                            self.performSegueWithIdentifier("patientScreen", sender: self)
                        }
                    }
            }
            
            let img = ImageEncoder.encoder(self.profilePicture.image!)
            
            if (image != img) {
                
                print("is it heeere?   ")
                
                Alamofire.upload(
                    .PUT,
                    "https://medhelp-app.herokuapp.com/api/patient/\(LoginInfo.id)/image", headers: headers,
                    multipartFormData: { multipartFormData in
                        if let imageData = UIImageJPEGRepresentation(self.profilePicture.image!, 0.25) {
                            multipartFormData.appendBodyPart(data: imageData, name: "profileImage", fileName: "file.png", mimeType: "image/png")
                        }
                        
                    },
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                            }
                        case .Failure(let encodingError):
                            print(encodingError)
                        }
                    }
                )
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
