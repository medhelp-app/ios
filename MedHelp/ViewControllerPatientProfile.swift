//
//  ViewControllerPatientProfile.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/22/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerPatientProfile: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var streetTextField: UILabel!
    @IBOutlet weak var zipCodeTextField: UILabel!
    @IBOutlet weak var cityTextField: UILabel!
    @IBOutlet weak var stateTextField: UILabel!
    @IBOutlet weak var countryTextField: UILabel!
    @IBOutlet weak var phoneTextField: UILabel!
    
    var name = ""
    var email = ""
    var street = ""
    var zipCode = ""
    var city = ""
    var state = ""
    var country = ""
    var phone = ""
    
    func cleanFields() {
        self.nameTextField.text = "Nome"
        self.emailTextField.text = "Email"
        self.streetTextField.text = "Endereço, número"
        self.zipCodeTextField.text = "CEP"
        self.cityTextField.text = "Cidade"
        self.stateTextField.text = "Estado"
        self.countryTextField.text = "País"
        self.phoneTextField.text = "Número"
    }
    
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
                        
                        self.fillFields()
                    }
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cleanFields()
        
        getPatientInfo()
        print("didload")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.styleCircleForImage(self.profilePicture)
        getPatientInfo()
        print("willappear")
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerPatientProfile.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}
