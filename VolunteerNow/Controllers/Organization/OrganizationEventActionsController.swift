//
//  OrganizationEventActionsController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 2/26/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class OrganizationEventActionsController: UIViewController {
    
    var actionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var checkInButton: UIButton!
    var sendMessageButton: UIButton!
    var viewSignupListButton: UIButton!
    
    var eventId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addShadowToBar()
        addShadowToTabBar()
        
        navigationItem.title = "Actions"

        checkInButton = createButton(withText: "Check In", selector: #selector(checkInButtonPressed))
        sendMessageButton = createButton(withText: "Send Message", selector: #selector(sendMessageButtonPressed))
        viewSignupListButton = createButton(withText: "View Signup List", selector: #selector(viewSignupListButtonPressed))
        
        actionButtonsStackView.addArrangedSubview(checkInButton)
        actionButtonsStackView.addArrangedSubview(sendMessageButton)
        actionButtonsStackView.addArrangedSubview(viewSignupListButton)
        
        view.addSubview(actionButtonsStackView)
        actionButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButtonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //actionButtonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        actionButtonsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -350).isActive = true
    }
    
    func createButton(withText text: String, selector: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.Custom.purple
        button.titleLabel?.font = UIFont.Custom.text
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 230).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }
    
    @objc func checkInButtonPressed() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "qrScannerController") as! QRScannerController
        viewController.eventId = eventId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func sendMessageButtonPressed() {
        print("Send Message Button")
    }
    
    @objc func viewSignupListButtonPressed() {
        print("View Signup List")
    }

}
