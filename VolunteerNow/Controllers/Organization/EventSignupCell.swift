//
//  EventSignupCell.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 3/3/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class EventSignupCell: UICollectionViewCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.text
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = UIColor.Custom.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
        setupViews()
    }
    
    func setupViews() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
