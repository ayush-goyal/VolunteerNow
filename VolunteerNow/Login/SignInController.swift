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
    @IBOutlet weak var emailInputLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var passwordInputLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordBorderView: UIView!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newUserLabel: UILabel!
    @IBOutlet weak var signupLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        
        setupViews()
    }
    
    
    func setupViews() {
    
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeSubLabel.translatesAutoresizingMaskIntoConstraints = false
        emailInputLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailBorderView.translatesAutoresizingMaskIntoConstraints = false
        passwordInputLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordBorderView.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        newUserLabel.translatesAutoresizingMaskIntoConstraints = false
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 40),
            welcomeSubLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            welcomeSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeSubLabel.heightAnchor.constraint(equalToConstant: 27),
            
            emailInputLabel.topAnchor.constraint(equalTo: welcomeSubLabel.bottomAnchor, constant: 75),
            emailInputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailInputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailInputLabel.heightAnchor.constraint(equalToConstant: 23),
            emailTextField.topAnchor.constraint(equalTo: emailInputLabel.bottomAnchor, constant: 6),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 30),
            emailBorderView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 3),
            emailBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailBorderView.heightAnchor.constraint(equalToConstant: 1),
            
            passwordInputLabel.topAnchor.constraint(equalTo: emailBorderView.bottomAnchor, constant: 50),
            passwordInputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordInputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordInputLabel.heightAnchor.constraint(equalToConstant: 23),
            passwordTextField.topAnchor.constraint(equalTo: passwordInputLabel.bottomAnchor, constant: 6),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            passwordBorderView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 3),
            passwordBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordBorderView.heightAnchor.constraint(equalToConstant: 1),
            
            forgotPasswordLabel.topAnchor.constraint(equalTo: passwordBorderView.bottomAnchor, constant: 20),
            forgotPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            forgotPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 23),
            
            loginButton.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -125),
            loginButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 125),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            newUserLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            newUserLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newUserLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
            newUserLabel.heightAnchor.constraint(equalToConstant: 23),
            
            signupLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            signupLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            signupLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signupLabel.heightAnchor.constraint(equalToConstant: 23),
        ])
    }

}
