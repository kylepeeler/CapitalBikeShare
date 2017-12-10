//
//  RidesTableViewController.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/9/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import UIKit

class RidesTableViewController: UITableViewController {
    override func viewDidAppear(_ animated: Bool) {
        let service = APIService()
        service.getRides()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name(rawValue: "RidesUpdated"), object: nil, queue: nil){
            notification in
            //Reload the table view
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ride.rides.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath)
        cell.textLabel?.text = Ride.convertDateToReadable(date: Ride.rides[indexPath.row].start_time!)
        cell.detailTextLabel?.text = Ride.convertCentsToReadable(cost: Ride.rides[indexPath.row].total_cost!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRideDetail" {
            let detailView = segue.destination as! RideDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRide = Ride.rides[indexPath.row]
                detailView.selectedRide = selectedRide
            }
        }
    }
}
