//
//  ActiveRideDetailViewController.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import UIKit
import MapKit

class ActiveRideDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var bikeCodeLabel: UILabel!
    @IBOutlet weak var unlockCodeLabel: UILabel!
    @IBOutlet weak var activeRideMap: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?
    
    var activeRide: ActiveRide!
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        activeRideMap.delegate = self
        self.navigationItem.setHidesBackButton(true, animated:false)

    }
    
    @IBAction func endRide(_ sender: Any) {
        let service = APIService()
        if let endRideLocation = currentLocation{
            service.endRide(rideID: activeRide.id!, location: endRideLocation)
            let nc = NotificationCenter.default
            nc.addObserver(forName: NSNotification.Name(rawValue: "RideEndedAndUpdated"), object: nil, queue: nil){
                notification in
                self.performSegue(withIdentifier: "endRide", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endRide" {
            let detailView = segue.destination as! RideDetailViewController
            let endedRide = Ride()
            endedRide.id = EndedRide.lastEndedRide.id
            endedRide.start_time = EndedRide.lastEndedRide.start_time
            endedRide.end_time = EndedRide.lastEndedRide.end_time
            endedRide.start_latitude = "\(activeRide.start_location.latitude)"
            endedRide.start_longitude = "\(activeRide.start_location.longitude)"
            endedRide.end_latitude = EndedRide.lastEndedRide.ending_latitude
            endedRide.end_longitude = EndedRide.lastEndedRide.ending_longitude
            endedRide.total_cost = EndedRide.lastEndedRide.total_cost
            endedRide.bike_code = EndedRide.lastEndedRide.bike_code
            detailView.selectedRide = endedRide
            
        }
    }
    
    func calculateCenterPoint(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let lon1: Double = location1.longitude * Double.pi / 180;
        let lon2: Double = location2.longitude * Double.pi / 180;
        
        let lat1: Double = location1.latitude * Double.pi / 180;
        let lat2: Double = location2.latitude * Double.pi / 180;
        
        let dLon: Double = lon2 - lon1;
        
        let x: Double = cos(lat2) * cos(dLon);
        let y: Double = cos(lat2) * sin(dLon);
        
        var lat3: Double = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) );
        var lon3: Double = lon1 + atan2(y, cos(lat1) + x);
        
        lat3  = lat3 * 180 / Double.pi;
        lon3 = lon3 * 180 / Double.pi;
        
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3, lon3)
        
        return center;
    }
    
    func calculateRegionSize(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> Double {
        let regionLocation1: CLLocation = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let regionLocation2: CLLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        let distanceInMeters: CLLocationDistance = regionLocation1.distance(from: regionLocation2)
        return distanceInMeters
    }
    
    func centerMapOnLocation(locationCoord: CLLocationCoordinate2D, distance: Double){
        //Define the region
        let mappedRegion = MKCoordinateRegionMakeWithDistance(locationCoord, distance, distance)
        //Move the map
        activeRideMap.setRegion(mappedRegion, animated: true);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.title = "Bike \(selectedBike.bike_code!) Detail"
        bikeCodeLabel.text = "\(activeRide.bike_code!)"
        unlockCodeLabel.text = "\(activeRide.unlock_code!)"
        
        centerMapOnLocation(locationCoord: activeRide.start_location, distance: 1000)
        let startLocationAnnotation: MKPointAnnotation = MKPointAnnotation()
        startLocationAnnotation.coordinate = activeRide.start_location
        startLocationAnnotation.title = "Starting Location"
        activeRideMap.addAnnotation(startLocationAnnotation)
    }
    
    // CLLocationManager Delegate FUNCTIONS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Calculate the center point
        let centerPoint: CLLocationCoordinate2D = calculateCenterPoint(location1: activeRide.start_location, location2: locations.last!.coordinate)
        //Calculate the region size
        let regionSize = calculateRegionSize(location1: activeRide.start_location, location2: locations.last!.coordinate)
        //Move the Map
        centerMapOnLocation(locationCoord: centerPoint, distance: regionSize)
        currentLocation = locations.last!.coordinate
    }

}
