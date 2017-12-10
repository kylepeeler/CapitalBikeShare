//
//  ProfileViewController.swift
//  BikeShare
//
//  Created by Kyle Peeler on 12/9/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAccessToken: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        lblAccessToken.text = UserDefaults.standard.string(forKey: "RequestToken")
        lblUsername.text = UserDefaults.standard.string(forKey: "Username")
    }
}
