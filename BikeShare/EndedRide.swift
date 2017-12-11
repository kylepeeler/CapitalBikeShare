//
//  ActiveRide.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import Foundation
import CoreLocation

class EndedRide: NSObject{
    var id: Int?
    var start_time: String?
    var end_time: String?
    var bike_code: Int?
    var status: Int?
    var ending_latitude: String?
    var ending_longitude: String?
    var total_cost: Int?
    var ending_location: CLLocationCoordinate2D{
        get{
            let latitudeVal = (ending_latitude! as NSString).doubleValue
            let longitudeVal = (ending_longitude! as NSString).doubleValue
            return CLLocationCoordinate2D(latitude: latitudeVal as CLLocationDegrees, longitude: longitudeVal as CLLocationDegrees)
            
        }
    }
    static var lastEndedRide = EndedRide()
}
