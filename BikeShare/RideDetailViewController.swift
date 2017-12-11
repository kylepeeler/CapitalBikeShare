//
//  RideDetailViewController.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import UIKit
import MapKit

class RideDetailViewController: UIViewController, MKMapViewDelegate {
    
    var selectedRide: Ride!
    @IBOutlet var bikeCodeLabel: UILabel!
    @IBOutlet var rideStartTimeLabel: UILabel!
    @IBOutlet var rideEndTimeLabel: UILabel!
    @IBOutlet var rideDurationLabel: UILabel!
    @IBOutlet var totalCostLabel: UILabel!
    @IBOutlet weak var startEndMap: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        rideStartTimeLabel.text = Ride.convertDateToReadable(date: selectedRide.start_time!)
        if let endTime = selectedRide.end_time{
            rideEndTimeLabel.text = Ride.convertDateToReadable(date: endTime)
        }else{
            rideEndTimeLabel.text = "Ride currently active"
        }
        totalCostLabel.text = Ride.convertCentsToReadable(cost: selectedRide.total_cost!)
        rideDurationLabel.text = selectedRide.time_difference
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        let service = APIService()
        service.getRide(id: selectedRide.id!)
        nc.addObserver(forName: NSNotification.Name(rawValue: "RideUpdated"), object: nil, queue: nil){
            notification in
            self.bikeCodeLabel.text = "\(self.selectedRide.bike_code!)"
        }
        if (selectedRide.end_latitude != nil && selectedRide.end_longitude != nil) {
            let centerPoint: CLLocationCoordinate2D = calculateCenterPoint(location1: selectedRide.start_location, location2: selectedRide.end_location)
            let regionSize = calculateRegionSize(location1: selectedRide.start_location, location2: selectedRide.end_location)
            centerMapOnLocation(locationCoord: centerPoint, distance: regionSize)
            let startAnnotation: MKPointAnnotation = MKPointAnnotation();
            startAnnotation.coordinate = selectedRide.start_location
            startAnnotation.title = "Starting Location"
            startEndMap.addAnnotation(startAnnotation)
            let stopAnnotation: MKPointAnnotation = MKPointAnnotation();
            stopAnnotation.coordinate = selectedRide.end_location
            stopAnnotation.title = "Ending Location"
            startEndMap.addAnnotation(stopAnnotation)
        }else{
            centerMapOnLocation(locationCoord: selectedRide.start_location, distance: 50)
            let startAnnotation: MKPointAnnotation = MKPointAnnotation();
            startAnnotation.coordinate = selectedRide.start_location
            startAnnotation.title = "Starting Location"
            startEndMap.addAnnotation(startAnnotation)
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
        // Create CLLocation Objects
        let regionLocation1: CLLocation = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let regionLocation2: CLLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        
        //Use built in function to calculate the distance between the two
        let distanceInMeters: CLLocationDistance = regionLocation1.distance(from: regionLocation2)
        
        return distanceInMeters
    }
    
    func centerMapOnLocation(locationCoord: CLLocationCoordinate2D, distance: Double){
        //Define the region
        let mappedRegion = MKCoordinateRegionMakeWithDistance(locationCoord, distance, distance)
        //Move the map
        startEndMap.setRegion(mappedRegion, animated: true);
    }
    
}
