//
//  BikeDetailViewController.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import UIKit
import MapKit

class BikeDetailViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    var selectedBike: Bike!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?

    @IBOutlet var bikeCodeLabel: UILabel!
    @IBOutlet weak var bikeMap: MKMapView!
    
    @IBAction func startRide(_ sender: UIButton) {
        let service = APIService()
        service.startRide(bikecode: selectedBike.bike_code!, location: selectedBike.bike_location)
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name(rawValue: "ActiveRideSet"), object: nil, queue: nil){
            notification in
            self.performSegue(withIdentifier: "startRide", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Bike \(selectedBike.bike_code!) Detail"
        bikeCodeLabel.text = "\(selectedBike.bike_code!)"
        centerMapOnLocation(locationCoord: selectedBike.bike_location, distance: 1000)
        let bikeLocationAnnotation: MKPointAnnotation = MKPointAnnotation()
        bikeLocationAnnotation.coordinate = selectedBike.bike_location
        bikeLocationAnnotation.title = "Bike \(selectedBike.bike_code!)'s Location"
        bikeMap.addAnnotation(bikeLocationAnnotation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    override func viewDidLoad() {
        bikeMap.delegate = self
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
        let mappedRegion = MKCoordinateRegionMakeWithDistance(locationCoord, distance, distance)
        bikeMap.setRegion(mappedRegion, animated: true);

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let centerPoint: CLLocationCoordinate2D = calculateCenterPoint(location1: selectedBike.bike_location, location2: locations.last!.coordinate)
        let regionSize = calculateRegionSize(location1: selectedBike.bike_location, location2: locations.last!.coordinate)
        centerMapOnLocation(locationCoord: centerPoint, distance: regionSize)
        currentLocation = locations.last!.coordinate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startRide" {
            let detailView = segue.destination as! ActiveRideDetailViewController
            detailView.activeRide = ActiveRide.currentRide
        }
    }

    
}
