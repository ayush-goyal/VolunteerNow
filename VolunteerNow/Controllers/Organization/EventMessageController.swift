//
//  EventMessageController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 2/26/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class EventMessageController: UIViewController {
    
    var messageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.subTitle
        label.text = "Message Title"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var messageTitleTextView: UITextView = {
        var textView = UITextView()
        textView.font = UIFont.Custom.text
        textView.backgroundColor = UIColor.Custom.lightGray
        textView.textColor = UIColor.Custom.darkGray
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var messageBodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.subTitle
        label.text = "Message Body"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var messageBodyTextView: UITextView = {
        var textView = UITextView()
        textView.font = UIFont.Custom.text
        textView.backgroundColor = UIColor.Custom.lightGray
        textView.textColor = UIColor.Custom.darkGray
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.Custom.purple
        button.titleLabel?.font = UIFont.Custom.text
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var eventId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        addShadowToTabBar()
        addShadowToBar()
        
        navigationItem.title = "Send Message"
        
        setupViews()
    }

    func setupViews() {
        view.addSubview(messageTitleLabel)
        view.addSubview(messageTitleTextView)
        view.addSubview(messageBodyLabel)
        view.addSubview(messageBodyTextView)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            messageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            messageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            messageTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            messageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            messageTitleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            messageTitleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            messageTitleTextView.topAnchor.constraint(equalTo: messageTitleLabel.bottomAnchor, constant: 20),
            messageTitleTextView.heightAnchor.constraint(equalToConstant: 33),
            
            messageBodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            messageBodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            messageBodyLabel.heightAnchor.constraint(equalToConstant: 25),
            messageBodyLabel.topAnchor.constraint(equalTo: messageTitleTextView.bottomAnchor, constant: 80),
            
            messageBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            messageBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            messageBodyTextView.topAnchor.constraint(equalTo: messageBodyLabel.bottomAnchor, constant: 20),
            messageBodyTextView.heightAnchor.constraint(equalToConstant: 93),
            
            sendButton.topAnchor.constraint(equalTo: messageBodyTextView.bottomAnchor, constant: 100),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 230),
            sendButton.heightAnchor.constraint(equalToConstant: 60),
        
        ])
        
    }
    
    @objc func sendMessage() {
        print("Sending message")
        APIManager.jsonTaskWithRoute("https://us-central1-volunteernowios.cloudfunctions.net/sendMessage", usingHTTPMethod: .post, postData: ["event": eventId, "title": messageTitleTextView.text, "message": messageBodyTextView.text]) { json, error in
            if let error = error {
                Popup.presentError(text: error.rawValue, viewController: self)
            } else {
                if let json = json, json["result"] as? String == "success" {
                    Popup.presentError(text: "Message sent successfully.", viewController: self, title: "Success")
                } else {
                    Popup.presentError(text: "Message sending failed.", viewController: self)
                }
            }
        }
        
            
    }

}
