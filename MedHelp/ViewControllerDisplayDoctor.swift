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

class ViewControllerDisplayDoctor: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var averageRating: CosmosView!
    @IBOutlet weak var ontime: CosmosView!
    @IBOutlet weak var attention: CosmosView!
    @IBOutlet weak var place: CosmosView!
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var doctorItem = DoctorItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.map.showsUserLocation = true
        
        self.averageRating.settings.fillMode = .Half
        
        self.profileImage.image = doctorItem.image
    }
    
    override func viewWillAppear(animated: Bool) {
        ImageCircle.styleCircleForImage(self.profileImage)
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.map.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("Error: " + error.localizedDescription)
    }
    
    @IBAction func openRatings(sender: AnyObject) {
    }
    
    @IBAction func rate(sender: AnyObject) {
    }
    
}