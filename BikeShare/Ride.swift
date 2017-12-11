//
//  Ride.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import Foundation
import CoreLocation

class Ride: NSObject {
    var id: Int?
    var start_time: String?
    var end_time: String?
    var start_latitude: String?
    var start_longitude: String?
    var end_latitude: String?
    var end_longitude: String?
    var total_cost: Int?
    var bike_code: Int?
    static var rides = [Ride]()
    var start_time_as_date: Date?{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            return dateFormatter.date(from: start_time!)
        }
    }
    var end_time_as_date: Date?{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            if let endTime = end_time{
                return dateFormatter.date(from: endTime)
            }else{
                return nil
            }
        }
    }
    var time_difference: String?{
        get{
            if end_time_as_date != nil {
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .full
                formatter.allowedUnits = [.month, .day, .hour, .minute, .second]
                formatter.maximumUnitCount = 2
                return formatter.string(from: start_time_as_date!, to: end_time_as_date!)
            }else{
                return "Ride currently active"
            }
            
        }
    }
    var start_location: CLLocationCoordinate2D{
        get{
            let latitude = (start_latitude! as NSString).doubleValue
            let longitude = (start_longitude! as NSString).doubleValue
            return CLLocationCoordinate2D(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)
        }

    }
    
    var end_location: CLLocationCoordinate2D{
        get{
            let latitude = (end_latitude! as NSString).doubleValue
            let longitude = (end_longitude! as NSString).doubleValue
            return CLLocationCoordinate2D(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees)
        }
    }

    static func convertDateToReadable(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    static func convertCentsToReadable(cost: Int) -> String{
        //cost is given in cents, so we should divide by 100
        let dollarCost = cost/100 as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: dollarCost)!
    }
    
    

}
