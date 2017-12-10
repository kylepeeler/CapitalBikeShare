//
//  Ride.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/10/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import Foundation

class Ride: NSObject {
    var id: Int?
    var start_time: String?
    var end_time: String?
    var start_latitude: String?
    var start_longitude: String?
    var end_latitude: String?
    var end_longitude: String?
    var total_cost: Int?
    static var rides = [Ride]()
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
