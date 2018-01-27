//
//  OrganizationSignInController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/23/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class OrganizationSignInController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeSubLabel: UILabel!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newOrganizationLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfAlreadySignedIn()
        
        codeTextField.titleFont = UIFont.init(name: "SofiaPro-Medium", size: 15)!
        
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true

        codeTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
        addShadowToBar()
        addShadowToTabBar()
        changeBackNavigationButton()
        
        setupViews()
    }
    
    func checkIfAlreadySignedIn() {
        let defaults = UserDefaults.standard
        
        if let organizationCode = defaults.string(forKey: "organizationCode") {
            App.shared.dbRef.child("organizations").child(organizationCode).observeSingleEvent(of: .value) { snapshot in
                let value = snapshot.value as? NSDictionary
                if let organizer = value?["organizer"] as? String, let website = value?["organizer"] as? String {
                    Organization.organizer = organizer
                    Organization.webste = website
                    Organization.id = organizationCode
                    self.performSegue(withIdentifier: "organizationHomeSegue", sender: nil)
                }
            }
        }
    }
    
    @objc func signIn() {
        guard let text = codeTextField.text else { return }
        App.shared.dbRef.child("organizations").child(text).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            if let organizer = value?["organizer"] as? String, let website = value?["organizer"] as? String {
                Organization.organizer = organizer
                Organization.webste = website
                Organization.id = text
                let defaults = UserDefaults.standard
                defaults.set(text, forKey: "organizationCode")
                self.performSegue(withIdentifier: "organizationHomeSegue", sender: nil)
                return
            } else {
                // Wrong code entered
                self.welcomeSubLabel.text = "Incorrect password entered"
                self.welcomeSubLabel.textColor = UIColor.red
                return
            }
        }
    }
    
    
    func setupViews() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeSubLabel.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        newOrganizationLabel.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 40),
            welcomeSubLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            welcomeSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeSubLabel.heightAnchor.constraint(equalToConstant: 55),
            
            codeTextField.topAnchor.constraint(greaterThanOrEqualTo: welcomeSubLabel.bottomAnchor, constant: 80), // Variable
            codeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.bottomAnchor.constraint(equalTo: newOrganizationLabel.topAnchor, constant: -30),
            loginButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 70),
            loginButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -125),
            loginButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 125),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            newOrganizationLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            newOrganizationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newOrganizationLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            newOrganizationLabel.heightAnchor.constraint(equalToConstant: 23),
            
            signupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            signupButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 23),
            ])
    }
    
}


extension OrganizationSignInController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
