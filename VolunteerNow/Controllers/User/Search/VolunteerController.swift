//
//  VolunteerController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/22/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class VolunteerController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar()
        addShadowToTabBar()
        
        navigationItem.title = "Volunteer"
        
        returnButton.layer.cornerRadius = 5
        returnButton.layer.masksToBounds = true
        
    }
    
    func setEventToFirebase(eventId: Int) {
        App.shared.dbRef.child("users").child(User.uid).observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? NSDictionary {
                if var upcoming = value["upcoming"] as? [Int] {
                    upcoming.append(eventId)
                    App.shared.dbRef.child("users/\(User.uid!)/upcoming").setValue(NSArray(array: upcoming))
                } else {
                    App.shared.dbRef.child("users/\(User.uid!)/upcoming").setValue(NSArray(array: [eventId]))
                }
            } else {
                App.shared.dbRef.child("users/\(User.uid!)/upcoming").setValue(NSArray(array: [eventId]))
            }
        }
    }

    @IBAction func popToContainerSearchController(_ sender: Any) {
        performSegue(withIdentifier: "volunteerControllerUnwind", sender: self)
    }
}
