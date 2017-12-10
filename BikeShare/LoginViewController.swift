//
//  ViewController.swift
//  BikeShare
//
//  Created by Kyle Peeler on 11/27/17.
//  Copyright © 2017 Kyle Peeler. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    @IBAction func clickLogin(_ sender: Any){
        let service = APIService()
        service.login(username: txtUsername.text!, password: txtPassword.text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name(rawValue: "RequestTokenFail"), object: nil, queue: nil) { notification in
            self.lblErrorMsg.text = "Invalid login!"
        }
        nc.addObserver(forName: NSNotification.Name(rawValue: "RequestTokenSuccess"), object: nil, queue: nil) { notification in
            print("Received valid request token")
            self.performSegue(withIdentifier: "segueValidLogin", sender: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

