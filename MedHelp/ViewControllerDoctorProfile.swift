//
//  ViewControllerDoctorScreen.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/15/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerDoctorProfile: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var crmNumberTextField: UILabel!
    @IBOutlet weak var crmStateTextField: UILabel!
    @IBOutlet weak var streetTextField: UILabel!
    @IBOutlet weak var zipCodeTextField: UILabel!
    @IBOutlet weak var cityTextField: UILabel!
    @IBOutlet weak var stateTextField: UILabel!
    @IBOutlet weak var countryTextField: UILabel!
    @IBOutlet weak var phoneTextField: UILabel!
    
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
                            self.profilePicture.image = ImageDecoder.decode(img)
                        }
                    }
                }
        }
    }
    
    func fillFields() {
        nameTextField.text = self.name != "" ? self.name : "Nome"
        emailTextField.text = self.email != "" ? self.email : "Email"
        streetTextField.text = self.street != "" ? self.street : "Endereço, número"
        zipCodeTextField.text = self.zipCode != "" ? self.zipCode : "CEP"
        cityTextField.text = self.city != "" ? self.city : "Cidade"
        stateTextField.text = self.state != "" ? self.state : "Estado"
        countryTextField.text = self.country != "" ? self.country : "País"
        phoneTextField.text = self.phone != "" ? self.phone : "Número de Telefone"
        crmNumberTextField.text = self.crmNumber != "" ? "CRM: \(self.crmNumber)" : "CRM: Número"
        crmStateTextField.text = self.crmState != "" ? "UF: \(self.crmState)" : "UF: Estado"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDoctorInfo()
        print("phone: " + self.phone)
        print("didload")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.styleCircleForImage(self.profilePicture)
        print("phone: " + self.phone)
        print("willappear")
    }
    
    override func viewDidAppear(animated: Bool) {
        print("phone: " + self.phone)
        print("didappear")
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
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let newImageView = UIImageView(image: self.profilePicture.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerDoctorProfile.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}
