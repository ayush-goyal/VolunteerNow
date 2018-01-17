//
//  EventDetailController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/16/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class EventDetailController: UIViewController {
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        sv.contentSize = CGSize(width: 1000, height: 1000)
        return sv
    }()

    var organizationLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.blue
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "SofiaPro-Bold", size: 22)
        return label
    }()
    
    var organizerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.red
        label.textColor = UIColor.white
        label.font = UIFont(name: "SofiaPro-SemiBold", size: 19)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.backgroundColor = UIColor.green
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        scrollView.addSubview(organizationLogoImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(organizerLabel)
        
        NSLayoutConstraint.activate([
            organizationLogoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            organizationLogoImageView.heightAnchor.constraint(equalToConstant: 110),
            organizationLogoImageView.widthAnchor.constraint(equalToConstant: 110),
            organizationLogoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: organizationLogoImageView.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 400),
            
            organizerLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            organizerLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            organizerLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            organizerLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }

}
