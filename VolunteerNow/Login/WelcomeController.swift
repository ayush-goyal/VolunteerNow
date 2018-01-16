//
//  WelcomeController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomeController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.font = UIFont(name: "Nunito-Bold", size: 42.0)
        
        //GIDSignIn.sharedInstance().signIn()
        setupGoogleSignIn()
        
    }
    
    func setupGoogleSignIn() {
        let googleButton = GIDSignInButton()
        view.addSubview(googleButton)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        googleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
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
