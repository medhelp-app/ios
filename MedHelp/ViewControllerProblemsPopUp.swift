//
//  ViewControllerProblemsPopUp.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/12/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerProblemsPopUp: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var problemsTable: UITableView!

    var problemsList = [String]()
    var width : CGFloat = 0
    var height : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.problemsTable.backgroundColor = UIColor(red:0.20, green:0.40, blue:0.60, alpha:1.0)
        self.preferredContentSize = CGSizeMake(self.width, self.height);
        self.loadList()
    }
    
    func loadList() {
        self.problemsTable.delegate = self
        self.problemsTable.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.problemsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier : String = "myCell"
        var cell = self.problemsTable.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = "\(self.problemsList[indexPath.row])"
        cell?.backgroundColor = UIColor(red:0.20, green:0.40, blue:0.60, alpha:1.0)
        cell?.textLabel?.textColor = UIColor.whiteColor()
        return cell!
    }
}