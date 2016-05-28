//
//  ViewControllerPatientSearchDoctor.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/27/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit

class ViewControllerSearchDoctor: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var doctorsArray = [DoctorItem]()
    var filteredDoctors = [DoctorItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doctorsArray += [DoctorItem(name : "Luiza Menezes", specialty: "Ginecologista Obstetra")]
        doctorsArray += [DoctorItem(name : "Luiza Cabral", specialty: "Demartologista")]
        doctorsArray += [DoctorItem(name : "Luiza Bezerra", specialty: "Cardiologista")]
        doctorsArray += [DoctorItem(name : "Carlos Rodrigo", specialty: "Dentista")]
        doctorsArray += [DoctorItem(name : "Carlos Garcia", specialty: "Clinico Geral")]
        doctorsArray += [DoctorItem(name : "Daniel Franca", specialty: "Dentista")]
        doctorsArray += [DoctorItem(name : "Charles de Oliveira", specialty: "Ginecologista Obstetra")]
        
        self.tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        print (doctor.name)
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
