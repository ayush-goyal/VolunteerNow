//
//  AddEventController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/22/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import Eureka
import PostalAddressRow
import Presentr
import CoreLocation

class AddEventController: FormViewController {
    
    var presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.presentationType = .alert
        
        let animation = CoverVerticalAnimation(options: .spring(duration: 1.0, delay: 0, damping: 0.7, velocity: 0))
        let coverVerticalWithSpring = TransitionType.custom(animation)
        presenter.transitionType = coverVerticalWithSpring
        presenter.dismissTransitionType = coverVerticalWithSpring
        presenter.backgroundOpacity = 0.5
        
        return presenter
    }()
    
    func presentError(text: String) {
        let alertController = Presentr.alertViewController(title: "Error", body: text)
        let okAction = AlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        addShadowToBar()
        addShadowToTabBar()
        
        setProperties()
        
        form +++ Section("General")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Enter event name"
                row.tag = "name"
            }
        
        form +++ Section("Date")
            <<< DateTimeRow(){
                $0.title = "Start Date"
                $0.value = Date(timeIntervalSinceReferenceDate: NSDate().timeIntervalSinceReferenceDate)
                $0.tag = "startDate"
            }
            <<< DateTimeRow(){
                $0.title = "End Date"
                $0.value = Date(timeIntervalSinceReferenceDate: NSDate().timeIntervalSinceReferenceDate + 2000)
                $0.tag = "endDate"
            }
        
        form +++ Section("Address")
            <<< PostalAddressRow() {
                $0.streetPlaceholder = "Street"
                $0.statePlaceholder = "State"
                $0.cityPlaceholder = "City"
                $0.postalCodePlaceholder = "Zip code"
                $0.tag = "address"
            }
        
        form +++ Section("Contact")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Enter contact name"
                row.tag = "contact-name"
            }
            <<< EmailRow(){ row in
                row.title = "Email"
                row.placeholder = "Enter contact email"
                row.tag = "contact-email"
            }
            <<< PhoneRow(){ row in
                row.title = "Phone Number"
                row.placeholder = "Enter contact number"
                row.tag = "contact-number"
            }
        
        form +++ Section("Details")
            <<< TextRow(){ row in
                row.title = "Event Details"
                row.placeholder = "Enter event details"
                row.tag = "details"
            }
        
        form +++ Section("Other")
            <<< URLRow(){ row in
                row.title = "Image URL"
                row.placeholder = "Enter event image URL"
                row.tag = "imageUrl"
            }
            <<< ButtonRow(){ row in
                row.title = "Submit"
                row.tag = "submit"
                row.cell.tintColor = UIColor.Custom.purple
                row.onCellSelection { cell, row in
                    self.submitForm()
                }
            }
    }
    
    func setProperties() {
        animateScroll = true
        rowKeyboardSpacing = 20
    }
    
    func submitForm() {
        let values = form.values()
        guard
            let name = values["name"] as? String,
            let startDate = values["startDate"] as? String,
            let endDate = values["endDate"] as? String,
            let address = values["address"] as? PostalAddress,
            let street = address.street,
            let city = address.city,
            let state = address.state,
            let zip = address.postalCode,
            let contactName = values["contact-name"] as? String,
            let contactEmail = values["contact-email"] as? String,
            let contactNumber = values["contact-number"] as? String,
            let details = values["details"] as? String,
            let imageUrl = values["imageUrl"] as? String
        else { presentError(text: "Please fill out all fields"); return }
        
        let formattedAddress = "\(street), \(city), \(state) \(zip)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(formattedAddress) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    self.presentError(text: "Address not found")
                    return
            }
            
            let json: [String: Any] = [
                "name": name,
                "organizer": "Pets",  // TODO: Fix this
                "startDate": startDate,
                "endDate": endDate,
                "address": [
                    "street": street,
                    "city": city,
                    "state": state,
                    "zip": zip
                ],
                "contact": [
                    "name": contactName,
                    "email": contactEmail,
                    "phone": contactNumber
                ],
                "details": [
                    "ages": "12+", // TODO: Fix this,
                    "description": details,
                    "organizer": "Pets aims to find homes for pets.", // TODO: Fix this
                    "setting": "Indoor" // TODO: Fix this
                ],
                "imageUrl": imageUrl,
                "type": "once",  // TODO: Fix this
                "website": "www.helppets.com",  // TODO: Fix this
                "tags": ["kids"],  // TODO: Fix this
                "id": 235322,  // TODO: Fix this
                "location": [
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude
                ]
            ]
            print(json)
        }
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
