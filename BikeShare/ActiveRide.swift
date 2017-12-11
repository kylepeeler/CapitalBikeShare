//
//  ActiveRide.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import Foundation
import CoreLocation

class ActiveRide: NSObject{
    var id: Int?
    var bike_code: Int?
    var unlock_code: Int?
    var status: Int?
    var latitude: String?
    var longitude: String?
    var start_location: CLLocationCoordinate2D{
        get{
            let latitudeVal = (latitude! as NSString).doubleValue
            let longitudeVal = (longitude! as NSString).doubleValue
            return CLLocationCoordinate2D(latitude: latitudeVal as CLLocationDegrees, longitude: longitudeVal as CLLocationDegrees)

        }
    }
    static var currentRide = ActiveRide()
}
