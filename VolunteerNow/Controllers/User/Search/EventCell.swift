//
//  EventCell.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/8/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

fileprivate let leftRightMargin: CGFloat = 30

class EventCell: UICollectionViewCell {
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = UIColor.green
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var backgroundImageTintView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: 220))
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.5)
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.blue
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "SofiaPro-Bold", size: 25)
        return label
    }()
    
    var organizerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.red
        label.numberOfLines = 0
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
        label.font = UIFont(name: "SofiaProRegular", size: 17)
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.brown
        label.textColor = UIColor.white
        label.font = UIFont(name: "SofiaProRegular", size: 17)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(organizerLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(backgroundImageTintView)
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: organizerLabel.topAnchor, constant: -15),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            organizerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            organizerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            organizerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -5),
            dateLabel.heightAnchor.constraint(equalToConstant: 19),
            
            distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 5),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            distanceLabel.heightAnchor.constraint(equalToConstant: 19),
            
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        sendSubview(toBack: backgroundImageView) // Prevents imageview from hiding text
        addShadow() // Adds shadow to cell
        
    }
    
    func setEventProperties(event: Event) {
        backgroundImageView.downloadedFrom(link: event.imageUrl)
        
        nameLabel.setTextandHeight(text: event.name, lineSpacing: 5, font: UIFont.Custom.mainTitle, alignment: .center, leftRightMargin: leftRightMargin)
        organizerLabel.setTextandHeight(text: event.organizer, lineSpacing: 0, font: UIFont.Custom.subTitle, alignment: .center, leftRightMargin: leftRightMargin)
        
        if let distance = event.distance {
            distanceLabel.text = "\(String(describing: distance)) miles away"
        }
        
        switch event.type {
        case .ongoing:
            dateLabel.text = "Ongoing Event"
        case .once(let startDate, let endDate):
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM dd"
            dateLabel.text = formatter.string(from: startDate)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
