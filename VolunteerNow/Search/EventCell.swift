//
//  EventCell.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/8/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = UIColor.green
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.blue
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "SofiaPro-Bold", size: 25)
        return label
    }()
    
    var organizerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.red
        label.textColor = UIColor.white
        label.font = UIFont(name: "SofiaPro-SemiBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.orange
        label.textColor = UIColor.white
        label.font = UIFont(name: "SofiaProRegular", size: 15)
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.brown
        label.textColor = UIColor.white
        label.font = UIFont(name: "SofiaProRegular", size: 15)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        contentView.addSubview(organizerLabel)
        NSLayoutConstraint.activate([
            organizerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            organizerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            organizerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            organizerLabel.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -5),
            dateLabel.heightAnchor.constraint(equalToConstant: 15)
            ])
        
        contentView.addSubview(distanceLabel)
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 5),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            distanceLabel.heightAnchor.constraint(equalToConstant: 15)
            ])
        
        contentView.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        
        sendSubview(toBack: backgroundImageView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
