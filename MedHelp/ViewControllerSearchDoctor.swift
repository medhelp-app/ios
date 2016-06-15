//
//  ViewControllerPatientSearchDoctor.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/27/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerSearchDoctor: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var doctorsArray = [DoctorItem]()
    var selectedDoctor = DoctorItem()
    
    func getSuggestions(searchString: String) {
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.GET, "https://medhelp-app.herokuapp.com/api/doctors/find/\(searchString)", headers: headers)
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    let array = JSON as? NSArray
                    
                    if (array?.count == 0 || array == nil) {
                        return
                    }
                    self.doctorsArray = [DoctorItem]()
                    for n in array! {
                        let doctors = n as! NSDictionary
                        
                        let id = doctors["_id"] as! String
                        let name = doctors["name"] as! String
                        var specialty = ""
                        if (doctors["doctorType"] != nil) {
                            if (doctors["doctorType"] !== NSNull()) {
                                specialty = doctors["doctorType"] as! String
                            }
                        }
                        var email = ""
                        if (doctors["email"] != nil) {
                            email = doctors["email"] as! String
                        }
                        var image = UIImage(named: "Profile")
                        if (doctors["profileImage"] != nil) {
                            if (doctors["profileImage"] as! String != "") {
                                image = ImageDecoder.decode(doctors["profileImage"] as! String)
                            }
                        }
                        
                        let item = DoctorItem(id: id, name: name, specialty: specialty, email: email, image: image!)
                        self.doctorsArray += [item]
                    }
                    
                    self.tableView.reloadData()
                    self.searchDisplayController?.searchResultsTableView.reloadData()
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "displayDoctor") {
            let destination = segue.destinationViewController as! ViewControllerDisplayDoctor
            
            destination.doctorItem = self.selectedDoctor
        }
    }
    
    
    // MARK - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctorsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.doctorsArray[indexPath.row].name
        cell.detailTextLabel?.text = self.doctorsArray[indexPath.row].specialty
        if (self.doctorsArray[indexPath.row].image != "") {
            cell.imageView?.image = self.doctorsArray[indexPath.row].image
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let doctor : DoctorItem = self.doctorsArray[indexPath.row]
        
        self.selectedDoctor = doctor
        
        self.performSegueWithIdentifier("displayDoctor", sender: self)
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        if (searchString == " ") {
            self.searchDisplayController?.searchBar.text = ""
            return true
        }
        self.doctorsArray = [DoctorItem]()
        self.getSuggestions(searchString!)
        
        return true
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print(searchBar.text)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
