//
//  BikesTableViewController.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/9/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import UIKit
import CoreLocation


class BikesTableViewController: UITableViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Calculate the center point
        if let location = locations.last{
            print("got latitude as \(location.coordinate.latitude)")
            print("got longitude as \(location.coordinate.longitude)")
        }
        
    }
}
