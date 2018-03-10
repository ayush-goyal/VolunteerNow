//
//  OrganizationProfileController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/23/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class OrganizationProfileController: UITableViewController {
    
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        organizerLabel.text = App.Organization.organizer
        websiteLabel.text = App.Organization.webste
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "organizationCode")
        switchToUserView(self)
    }
    
    @IBAction func switchToUserView(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "userTabBarController")
        
        present(viewController, animated: true, completion: nil)
    }
    
}

