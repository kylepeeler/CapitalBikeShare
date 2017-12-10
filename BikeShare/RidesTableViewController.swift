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
        if let ride = Ride.rides[indexPath.row] as? Ride {
            let dateFormatter = DateFormatter()
            cell.textLabel?.text = Ride.convertDateToReadable(date: ride.start_time!)
            cell.detailTextLabel?.text = Ride.convertCentsToReadable(cost: ride.total_cost!)
        }
        return cell
    }
}
