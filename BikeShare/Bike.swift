//
//  Ride.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import Foundation
import CoreLocation

class Bike: NSObject {
    var bike_code: Int?
    var distance: Double?
    var latitude: String?
    var longitude: String?
    var status: Int?
    static var bikes = [Bike]()
    var bike_location: CLLocationCoordinate2D{
        get{
            let latitude = (self.latitude! as NSString).doubleValue
            let longitude = (self.longitude! as NSString).doubleValue
            return CLLocationCoordinate2D(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)
        }
    }
}
