//
//  EventDetailController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/16/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import  MapKit

class EventDetailController: UIViewController {
    
    private let leftRightMargin: CGFloat = 22
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1300)
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
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var organizerHeadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Custom.darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Description"
        label.font = UIFont.Custom.heading
        return label
    }()
    
    var descriptionInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.Custom.text
        return label
    }()
    
    var organizerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Organizer"
        label.font = UIFont.Custom.heading
        return label
    }()
    
    var organizerInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.Custom.darkGray
        label.font = UIFont.Custom.text
        return label
    }()
    
    var dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "date").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.Custom.darkGray
        return imageView
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = UIColor.Custom.darkGray
        label.font = UIFont.Custom.text
        return label
    }()
    
    var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "locationPin").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.Custom.darkGray
        return imageView
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.Custom.darkGray
        label.font = UIFont.Custom.text
        return label
    }()
    
    let locationMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var volunteerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.Custom.subTitle
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.Custom.purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isVolunteerButton: Bool = true
    
    private var eventID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Details"
        
        addShadowToBar()
        addShadowToTabBar()
        setupViews()
        
        if isVolunteerButton {
            volunteerButton.setTitle("Volunteer Now!", for: .normal)
            volunteerButton.addTarget(self, action: #selector(volunteerButtonPressed), for: .touchUpInside)
        } else {
            volunteerButton.setTitle("Check In", for: .normal)
             volunteerButton.addTarget(self, action: #selector(checkInButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func volunteerButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "volunteerController") as! VolunteerController
        viewController.setEventToFirebase(eventId: eventID)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func checkInButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "qrScannerController") as! QRScannerController
        self.navigationController?.pushViewController(viewController, animated: true)
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
        scrollView.addSubview(dateImageView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(locationImageView)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(locationMapView)
        
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
            
            descriptionLabel.topAnchor.constraint(equalTo: organizerHeadingLabel.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionInfoLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            descriptionInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            
            organizerLabel.topAnchor.constraint(equalTo: descriptionInfoLabel.bottomAnchor, constant: 25),
            organizerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            organizerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            organizerLabel.heightAnchor.constraint(equalToConstant: 20),
            
            organizerInfoLabel.topAnchor.constraint(equalTo: organizerLabel.bottomAnchor, constant: 10),
            organizerInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightMargin),
            organizerInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightMargin),
            
            dateImageView.topAnchor.constraint(equalTo: organizerInfoLabel.bottomAnchor, constant: 30),
            dateImageView.heightAnchor.constraint(equalToConstant: 60),
            dateImageView.widthAnchor.constraint(equalToConstant: 60),
            dateImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dateImageView.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            locationMapView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            locationMapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            locationMapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            locationMapView.heightAnchor.constraint(equalToConstant: 170),
            
            locationImageView.topAnchor.constraint(equalTo: locationMapView.bottomAnchor, constant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 60),
            locationImageView.widthAnchor.constraint(equalToConstant: 60),
            locationImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 18),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
        ])
        
    }
    
    func setValues(withEvent event: Event) {
        nameHeadingLabel.setTextandHeight(text: event.name, lineSpacing: 13, font: UIFont.Custom.mainTitle, alignment: .center, leftRightMargin: leftRightMargin)
        organizerHeadingLabel.setTextandHeight(text: event.organizer, lineSpacing: 0, font: UIFont.Custom.subTitle, alignment: .center, leftRightMargin: leftRightMargin)
        
        descriptionInfoLabel.setTextandHeight(text: event.details.description, lineSpacing: 3, font: UIFont.Custom.text, alignment: .left, leftRightMargin: leftRightMargin)
        organizerInfoLabel.setTextandHeight(text: event.details.organizer, lineSpacing: 3, font: UIFont.Custom.text, alignment: .left, leftRightMargin: leftRightMargin)
        
        switch event.type {
        case .ongoing:
            organizerInfoLabel.setTextandHeight(text: "Ongoing Event", lineSpacing: 1, font: UIFont.Custom.text, alignment: .center, leftRightMargin: 40)
        case .once(let startDate, let endDate):
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM d, yyyy"
            var dateString = formatter.string(from: startDate) + "\n"
            formatter.dateFormat = "h:mm a"
            dateString = dateString + formatter.string(from: startDate) + " - " + formatter.string(from: endDate)
            dateLabel.setTextandHeight(text: dateString, lineSpacing: 7, font: UIFont.Custom.text, alignment: .center, leftRightMargin: 40)
        }
        
        if let distance = event.distance {
            let locationString = String(distance) + " miles away\n" + event.address.print
            locationLabel.setTextandHeight(text: locationString, lineSpacing: 7, font: UIFont.Custom.text, alignment: .center, leftRightMargin: 40)
        } else {
            locationLabel.setTextandHeight(text: event.address.print, lineSpacing: 7, font: UIFont.Custom.text, alignment: .center, leftRightMargin: 40)
        }
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(event.coordinate, 2000, 2000)
        locationMapView.setRegion(viewRegion, animated: true)
        locationMapView.addAnnotation(event)
        
        eventID = event.id
    }

}

extension EventDetailController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "event"
        var annotationView: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.isEnabled = false
        }
        return annotationView
    }
}

