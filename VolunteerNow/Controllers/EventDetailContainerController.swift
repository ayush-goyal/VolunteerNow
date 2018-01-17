//
//  EventDetailContainerController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/16/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class EventDetailContainerController: UIViewController {
    
    var eventDetailController: EventDetailController = {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "eventDetailController") as! EventDetailController
        let controller = EventDetailController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    var volunteerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SofiaPro-Medium", size: 18)
        button.setTitle("Volunteer Now!", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.Custom.purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Details"
        
        addShadowToBar()
        addShadowToTabBar()
        setupViews()
    }
    
    func setupViews() {
        
        addChildViewController(eventDetailController)
        view.addSubview(eventDetailController.view)
        view.addSubview(volunteerButton)
        
        NSLayoutConstraint.activate([
            eventDetailController.view.bottomAnchor.constraint(equalTo: volunteerButton.topAnchor),
            eventDetailController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: self.navigationController!.navigationBar.frame.height),
            eventDetailController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            eventDetailController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            volunteerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            volunteerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            volunteerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height),
            volunteerButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
    }

}
