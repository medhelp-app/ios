//
//  ViewControllerDisplayDoctor.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/31/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Cosmos
import MapKit
import CoreLocation

class ViewControllerDisplayDoctor: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate  {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var averageRating: CosmosView!
    @IBOutlet weak var ontime: CosmosView!
    @IBOutlet weak var attention: CosmosView!
    @IBOutlet weak var place: CosmosView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var numberRatings: UILabel!
    
    let locationManager = CLLocationManager()
    
    var doctorItem = DoctorItem()
    
    var street = "estrada de belem, 279"
    var zipCode = "52130000"
    var city = "recife"
    var state = "pe"
    var country = "brasil"
    
    func loadDoctorInfo() {
        Alamofire.request(.GET, URLHelper.getDoctorInfo(self.doctorItem.id), headers: URLHelper.getHeader())
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        print (keyExists)
                    } else {
                        self.numberLabel.text = (dict!["phone"] as? String)!
                        print("numero: \((dict!["phone"] as? String)!)")
                        self.street = (dict!["addressStreet"] as? String)!
                        self.zipCode = (dict!["zipCode"] as? String)!
                        self.city = (dict!["city"] as? String)!
                        self.state = (dict!["state"] as? String)!
                        self.country = (dict!["country"] as? String)!
                        
                        self.loadPin()
                    }
                }
        }
    }

    func loadSumarryOpinions() {
        Alamofire.request(.GET, URLHelper.getDoctorsOpnionSummary(self.doctorItem.id), headers: URLHelper.getHeader())
            .responseJSON { response in
                //debugPrint(response)
                if let JSON = response.result.value {
                    
                    let dict = JSON as? NSDictionary
                    
                    let keyExists = dict!["error"] != nil
                    
                    if keyExists {
                        print (keyExists)
                    } else {
                        self.averageRating.rating = (dict!["generalRating"] as? Double)!
                        self.ontime.rating = (dict!["punctualityRating"] as? Double)!
                        self.attention.rating = (dict!["attentionRating"] as? Double)!
                        self.place.rating = (dict!["installationRating"] as? Double)!
                        self.numberRatings.text =  "Baseado em \((dict!["numberOfEvaluations"] as? Int)!) opiniões"
                    }
                }
        }
    }
    
    func loadPin() {
        //var annotation:MKAnnotation!
        var localSearchRequest:MKLocalSearchRequest!
        var localSearch:MKLocalSearch!
        //var localSearchResponse:MKLocalSearchResponse!
        //var error:NSError!
        var pointAnnotation:MKPointAnnotation!
        var pinAnnotationView:MKPinAnnotationView!
        
        let address = "\(self.street), \(self.city), \(self.state), \(self.zipCode), \(self.country)"
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Endereço não encontrado", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = self.doctorItem.name
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.map.centerCoordinate = pointAnnotation.coordinate
            self.map.addAnnotation(pinAnnotationView.annotation!)
        }
        
    }
    
    func loadMap() {
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.map.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDoctorInfo()
        
        self.loadMap()
        
        self.loadSumarryOpinions()
        
        self.nameLabel.text = self.doctorItem.name
        
        self.emailLabel.text = self.doctorItem.email
        
        self.profileImage.image = doctorItem.image
        
        self.averageRating.settings.fillMode = .Half
        self.ontime.settings.fillMode = .Half
        self.attention.settings.fillMode = .Half
        self.place.settings.fillMode = .Half
    }
    
    override func viewWillAppear(animated: Bool) {
        ImageCircle.styleCircleForImage(self.profileImage)
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.map.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("Error: " + error.localizedDescription)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rating" {
            let vc = segue.destinationViewController
            
            let controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
            }
            
            let destination = vc as! ViewControllerRating
        }
    }
    
    @IBAction func openRatings(sender: AnyObject) {
        
    }
    
    @IBAction func rate(sender: AnyObject) {
        self.performSegueWithIdentifier("rating", sender: self)
    }
    
}