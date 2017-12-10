//
//  APIService.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/9/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import Foundation

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
                        UserDefaults.standard.set(user, forKey: "username")
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
}
