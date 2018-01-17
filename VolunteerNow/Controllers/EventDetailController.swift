//
//  EventDetailController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/16/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

fileprivate let leftRightMargin: CGFloat = 22

class EventDetailController: UIViewController {
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1400)
        sv.backgroundColor = UIColor.white
        return sv
    }()
    
    var organizationLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var nameHeadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.red
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var organizerHeadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.red
        label.textColor = UIColor.Custom.darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.green
        label.textColor = UIColor.black
        label.text = "Description"
        label.font = UIFont.Custom.heading
        return label
    }()
    
    var descriptionInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.green
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.Custom.text
        return label
    }()
    
    var organizerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.green
        label.textColor = UIColor.black
        label.text = "Organizer"
        label.font = UIFont.Custom.heading
        return label
    }()
    
    var organizerInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.green
        label.numberOfLines = 0
        label.textColor = UIColor.Custom.darkGray
        label.font = UIFont.Custom.text
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.green
        label.numberOfLines = 2
        label.textColor = UIColor.Custom.darkGray
        label.font = UIFont.Custom.text
        return label
    }()
    
    var volunteerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.Custom.subTitle
        button.setTitle("Volunteer Now!", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.Custom.purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Details"
        
        addShadowToBar()
        addShadowToTabBar()
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(scrollView)
        view.addSubview(volunteerButton)
        
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: volunteerButton.topAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.navigationController!.navigationBar.frame.height),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            volunteerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            volunteerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            volunteerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height),
            volunteerButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        view.sendSubview(toBack: scrollView) // Allows nav bar shadow to be seen
        
        scrollView.addSubview(organizationLogoImageView)
        scrollView.addSubview(nameHeadingLabel)
        scrollView.addSubview(organizerHeadingLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionInfoLabel)
        scrollView.addSubview(organizerLabel)
        scrollView.addSubview(organizerInfoLabel)
        
        NSLayoutConstraint.activate([
            organizationLogoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            organizationLogoImageView.heightAnchor.constraint(equalToConstant: 110),
            organizationLogoImageView.widthAnchor.constraint(equalToConstant: 110),
            organizationLogoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameHeadingLabel.topAnchor.constraint(equalTo: organizationLogoImageView.bottomAnchor, constant: 30),
            nameHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            nameHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            
            organizerHeadingLabel.topAnchor.constraint(equalTo: nameHeadingLabel.bottomAnchor, constant: 15),
            organizerHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            organizerHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            
            descriptionLabel.topAnchor.constraint(equalTo: organizerHeadingLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionInfoLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            descriptionInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            descriptionInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            
            organizerLabel.topAnchor.constraint(equalTo: descriptionInfoLabel.bottomAnchor, constant: 20),
            organizerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            organizerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            organizerLabel.heightAnchor.constraint(equalToConstant: 20),
            
            organizerInfoLabel.topAnchor.constraint(equalTo: organizerLabel.bottomAnchor, constant: 20),
            organizerInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            organizerInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin)
        ])
        
    }
    
    func setValues(withEvent event: Event) {
        nameHeadingLabel.setTextandHeight(text: event.name, lineSpacing: 13, font: UIFont.Custom.mainTitle, alignment: .center)
        organizerHeadingLabel.setTextandHeight(text: event.organizer, lineSpacing: 0, font: UIFont.Custom.subTitle, alignment: .center)
        
        descriptionInfoLabel.setTextandHeight(text: event.name, lineSpacing: 3, font: UIFont.Custom.text, alignment: .left)
        organizerInfoLabel.setTextandHeight(text: event.organizer, lineSpacing: 3, font: UIFont.Custom.text, alignment: .left)
    }

}


fileprivate extension UIFont {
    struct Custom {
        static let mainTitle = UIFont(name: "SofiaPro-Bold", size: 23)!
        static let subTitle = UIFont(name: "SofiaPro-SemiBold", size: 20)!
        static let heading = UIFont(name: "SofiaPro-Bold", size: 18)!
        static let text = UIFont(name: "SofiaPro-Medium", size: 18)!
    }
}

fileprivate extension UILabel {
    func setTextandHeight(text: String, lineSpacing: CGFloat, font: UIFont, alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: font]
        
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        
        let width = UIScreen.main.bounds.width-(leftRightMargin * 2)
        let size = CGSize(width: width, height: 400)
        
        let frame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        self.attributedText = attributedText
        self.heightAnchor.constraint(equalToConstant: frame.height+5)
        
    }
}

