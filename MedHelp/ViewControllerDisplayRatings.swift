//
//  ViewControllerDisplayRatings.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/15/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Cosmos

class ViewControllerDisplayRatings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var ratings: UITableView!
    
    var width : CGFloat = 400
    var height : CGFloat = 390
    
    var id : String = ""
    
    var ratingList = [RatingItem]()

    func loadRatings() {
        self.ratingList = [RatingItem]()
        Alamofire.request(.GET, URLHelper.getDoctorsOpnion(id), headers: URLHelper.getHeader())
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    
                    let array = JSON as? NSArray
                    
                    if array != nil {
                        if array?.count > 0 {
                            for element in array! {
                                let e = element as? NSDictionary
                                
                                let comment = e!["comment"] as! String
                                let ratingScore = e!["generalRating"] as! Double
                                
                                let rating = RatingItem(comment: comment, rating: ratingScore)
                                self.ratingList += [rating]
                            }
                            self.ratings.reloadData()
                        }
                    }
                    
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratings.dataSource = self
        self.ratings.delegate = self
        self.ratings.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        
        self.ratings.backgroundColor = UIColor(red:0.20, green:0.40, blue:0.60, alpha:1.0)
        self.preferredContentSize = CGSizeMake(self.width, self.height);
        
        self.loadRatings()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratingList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(130)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let identifier : String = "RatingCell"
        let cell : RatingCell = self.ratings.dequeueReusableCellWithIdentifier(identifier) as! RatingCell
   
        
        cell.comment.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.comment.text = "\(self.ratingList[indexPath.row].comment)"
        cell.rating.settings.fillMode = .Half
        cell.rating.rating = self.ratingList[indexPath.row].rating
        cell.backgroundColor = UIColor(red:0.20, green:0.40, blue:0.60, alpha:1.0)
        
        return cell
    }
}