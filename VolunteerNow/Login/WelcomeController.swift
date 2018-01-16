//
//  WelcomeController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.font = UIFont(name: "Nunito-Bold", size: 42.0)
        signupButton.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 19.0)
        loginButton.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 19.0)

        let defaults = UserDefaults.standard
        defaults.set("Ayush Goyal", forKey: "name")
        
        let userID = Int(drand48() * 1000000)
        defaults.set(userID, forKey: "id")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
