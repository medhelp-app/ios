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
    var filteredDoctors = [DoctorItem]()
    var doctorsName = [String]()
    var sendName = ""
    
    func getSuggestions() {
        let headers = [
            "x-access-token": "\(LoginInfo.token)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(.GET, "https://medhelp-app.herokuapp.com/api/doctors/find/suggestions", headers: headers)
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    let array = JSON as? NSArray
                    self.doctorsName = [String]()
                    print("array \(array?.count)")
                    for n in 0...(array!.count - 2) {
                        if (array![n] !== NSNull()) {
                            print(array![n])
                            print(array![n] as! String)
                            self.doctorsName += [array![n] as! String]
                       }
                    }
                    print(self.doctorsName.count)
                    self.fillTable()
                }
        }
    }
    
    func fillTable() {
        if (self.doctorsName.count > 0) {
            for i in 0...(self.doctorsName.count - 1) {
                doctorsArray += [DoctorItem(name : self.doctorsName[i], specialty: "Especialidade")]
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSuggestions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "patientScreen") {
            let tabBarController = segue.destinationViewController as! UITabBarController
            
            let destination = tabBarController.viewControllers![0] as! ViewControllerDisplayDoctor
            
            destination.name = self.sendName
        }
    }
    
    
    // MARK - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            return self.filteredDoctors.count
        } else {
            return self.doctorsArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var doctor : DoctorItem
        
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            doctor = self.filteredDoctors[indexPath.row]
        } else {
            doctor = self.doctorsArray[indexPath.row]
        }
        
        cell.textLabel?.text = doctor.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var doctor : DoctorItem
        
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            
            doctor = self.filteredDoctors[indexPath.row]
            
        } else {
            
            doctor = self.doctorsArray[indexPath.row]
            
        }
        
        self.sendName = doctor.name
        self.performSegueWithIdentifier("displayDoctor", sender: self)
    }
    
    // Mark - Search
    
    func filterContentForSearchText(searchText : String, scope : String = "Title") {
        
        self.filteredDoctors = self.doctorsArray.filter({(doctor : DoctorItem) -> Bool in
          
            let categoryMatch = (scope == "Title")
            let stringMatch = doctor.name.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil)
            
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        
        self.filterContentForSearchText(searchString!, scope: "Title")
        
        return true
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
        self.filterContentForSearchText((self.searchDisplayController?.searchBar.text)!, scope: "Title")
        
        return true
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
