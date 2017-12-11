//
//  APIService.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/9/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import Foundation
import CoreLocation

class APIService: NSObject {
    let baseURL = "bikeshare-iupui-fa17.herokuapp.com/api/v1/"
    
    func login(username: String, password: String){
        let urlString = "https://" + username + ":" + password + "@" + baseURL + "users/login"
        print("logging in at \(urlString)")
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var requestToken = String()
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let parsedResult = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    print(parsedResult);
                    if let apiRequestToken = parsedResult["user"]!["single_access_token"] {
                        requestToken = apiRequestToken as! String
                        let user = parsedResult["user"]!["username"] as! String
                        UserDefaults.standard.set(user, forKey: "Username")
                        UserDefaults.standard.set(requestToken, forKey: "RequestToken")
                        
                        DispatchQueue.main.async() {
                            let nc = NotificationCenter.default
                            nc.post(name: NSNotification.Name(rawValue: "RequestTokenSuccess"), object: nil)
                        }
                    }
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async() {
                    let nc = NotificationCenter.default
                    nc.post(name: NSNotification.Name(rawValue: "RequestTokenFail"), object: nil)
                }
            }
        }.resume()
    }
    
    func getRides(){
        guard let token = UserDefaults.standard.string(forKey: "RequestToken") else{
            return
        }
        let urlString = "https://" + baseURL + "rides/" + token
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let parsedResult = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    print("parsed result is \(parsedResult)")
                    if let rides = parsedResult["rides"] as? [[String: AnyObject]] {
                        print("rides is \(rides)")
                        Ride.rides = [Ride]()
                        for dict in rides {
                            let ride = Ride()
                            ride.id = dict["id"] as? Int
                            ride.start_time = dict["start"] as? String
                            ride.end_time = dict["end"] as? String
                            ride.start_latitude = dict["start_latitude"] as? String
                            ride.start_longitude = dict["start_longitude"] as? String
                            ride.end_latitude = dict["end_latitude"] as? String
                            ride.end_longitude = dict["longitude"] as? String
                            ride.total_cost = dict["total_cost"] as? Int
                            Ride.rides.append(ride)
                        }
                        // Once we have parsed all of the rides, send a notification
                        DispatchQueue.main.async{
                            let nc = NotificationCenter.default
                            nc.post(name: NSNotification.Name(rawValue: "RidesUpdated"), object: nil)
                        }
                    } else {
                        print("Unable to get rides")
                    }
                }
            } catch let error {
                // SESSION FAILURE
                print(error)
            }
        }.resume()
    }
    
    func getRide(id: Int){
        guard let token = UserDefaults.standard.string(forKey: "RequestToken") else{
            return
        }
        let urlString = "https://" + baseURL + "rides/" + token + "/" + "\(id)"
        print("getting ride \(id) with url \(urlString)")
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let parsedResult = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    if let result = parsedResult["ride"] as? [String: AnyObject] {
                        if let i = Ride.rides.index(where: {$0.id! == result["id"] as! Int}){
                            Ride.rides[i].bike_code = result["bike_code"] as? Int
                            DispatchQueue.main.async{
                                let nc = NotificationCenter.default
                                nc.post(name: NSNotification.Name(rawValue: "RideUpdated"), object: nil)
                            }
                        }
                    } else {
                       print("Unable to get ride id \(id)")
                    }
                }
            } catch let error {
                // SESSION FAILURE
                print(error)
            }
        }.resume()
    }
    
    func getBikes(latitude: String, longitude: String, distance: Int){
        guard let token = UserDefaults.standard.string(forKey: "RequestToken") else{
            return
        }
        let urlString = "https://" + baseURL + "bikes/near/" + token + "/" + latitude + "/" + longitude + "/" + "\(distance)"
        print("getting bikes at URL \(urlString)")
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let parsedResult = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    if let bikes = parsedResult["bikes"] as? [[String: AnyObject]] {
                        Bike.bikes = [Bike]()
                        for dict in bikes {
                            let bike = Bike()
                            bike.bike_code = dict["bike_code"] as? Int
                            bike.distance = dict["distance"] as? Double
                            bike.latitude = dict["latitude"] as? String
                            bike.longitude = dict["longitude"] as? String
                            bike.status = dict["status"] as? Int
                            Bike.bikes.append(bike)
                        }
                        DispatchQueue.main.async{
                            let nc = NotificationCenter.default
                            nc.post(name: NSNotification.Name(rawValue: "BikesUpdated"), object: nil)
                        }
                    } else {
                        print("Unable to get bikes")
                    }
                }
            } catch let error {
                // SESSION FAILURE
                print(error)
            }
        }.resume()
    }
    
    func startRide(bikecode: Int, location: CLLocationCoordinate2D){
        guard let token = UserDefaults.standard.string(forKey: "RequestToken") else{
            return
        }
        let urlString = "https://" + baseURL + "rides/startride/" + token + "/" + "\(bikecode)" + "/\(location.latitude)/\(location.longitude)"
        print("starting ride at URL \(urlString)")
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let parsedResult = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    if let result = parsedResult["ride"] as? [String: AnyObject] {                            let activeRide = ActiveRide.currentRide
                        activeRide.bike_code = result["bike_code"] as? Int
                        activeRide.id = result["id"] as? Int
                        activeRide.unlock_code = result["unlock_code"] as? Int
                        activeRide.status = result["status"] as? Int
                        activeRide.latitude = result["latitude"] as? String
                        activeRide.longitude = result["longitude"] as? String
                        DispatchQueue.main.async {
                            let nc = NotificationCenter.default
                            nc.post(name: NSNotification.Name(rawValue: "ActiveRideSet"), object: nil)
                        }
                    } else {
                        print("Unable to start ride")
                    }
                }
            } catch let error {
                // SESSION FAILURE
                print(error)
            }
            }.resume()
    }
}
