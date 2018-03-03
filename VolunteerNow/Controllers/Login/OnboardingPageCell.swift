//
//  OnboardingPageCell.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 3/3/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

struct OnboardingPage {
    let headerText: String
    let bodyText: String
}

class OnboardingPageCell: UICollectionViewCell {
    var onboardingPage: OnboardingPage? {
        didSet {
            guard let page = onboardingPage else { return }
            headerLabel.text = page.headerText
            bodyLabel.text = page.bodyText
        }
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.mainTitle
        label.textAlignment = .center
        label.textColor = UIColor.Custom.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.subTitle
        label.textAlignment = .center
        label.textColor = UIColor.Custom.lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(headerLabel)
        addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
                headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70),
                headerLabel.heightAnchor.constraint(equalToConstant: 90),
                headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
                
                bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
                bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
                bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -175)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
