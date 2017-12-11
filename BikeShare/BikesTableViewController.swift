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
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name(rawValue: "BikesUpdated"), object: nil, queue: nil){
            notification in
            //Reload the table view
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let service = APIService()
            service.getBikes(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)", distance: 1)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bike.bikes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)
        cell.textLabel?.text = "\(Bike.bikes[indexPath.row].bike_code!)"
        cell.detailTextLabel?.text = "\(Bike.bikes[indexPath.row].distance!) miles"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBikeDetail" {
            let detailView = segue.destination as! BikeDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedBike = Bike.bikes[indexPath.row]
                detailView.selectedBike = selectedBike
            }
        }
    }

}
