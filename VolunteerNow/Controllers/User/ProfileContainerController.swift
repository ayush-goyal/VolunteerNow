//
//  ProfileContainerController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/15/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class ProfileContainerController: UIViewController {

    @IBOutlet weak var profileControllerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar()
        addShadowToTabBar()
        changeBackNavigationButton()
        
        profileControllerContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                profileControllerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
                profileControllerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                profileControllerContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                profileControllerContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}
