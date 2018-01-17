//
//  SignInController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/15/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class SignInController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeSubLabel: UILabel!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newUserLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        
        emailTextField.iconType = .image
        emailTextField.titleFont = UIFont.init(name: "SofiaPro-Medium", size: 15)!
        passwordTextField.iconType = .image
        passwordTextField.titleFont = UIFont.init(name: "SofiaPro-Medium", size: 15)!
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        hideKeyboardWhenTappedAround()
        
        addShadowToBar()
        changeBackNavigationButton()
        setupViews()
    }

    
    
    func setupViews() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeSubLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        newUserLabel.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 120), // Variable
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 40),
            welcomeSubLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            welcomeSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeSubLabel.heightAnchor.constraint(equalToConstant: 27),
            
            emailTextField.topAnchor.constraint(lessThanOrEqualTo: welcomeSubLabel.bottomAnchor, constant: 80),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 60),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 23),
            
            loginButton.bottomAnchor.constraint(equalTo: newUserLabel.topAnchor, constant: -30),
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 80),
            loginButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -125),
            loginButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 125),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            newUserLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            newUserLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newUserLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
            newUserLabel.heightAnchor.constraint(equalToConstant: 23),
            
            signupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            signupButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 23),
        ])
    }

}


extension SignInController: UITextFieldDelegate {
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
