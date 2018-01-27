//
//  CheckInConfirmationController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/26/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class CheckInConfirmationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func scanAgain(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
