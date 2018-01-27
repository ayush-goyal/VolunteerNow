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

class AddEventController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar()
        addShadowToTabBar()
        
        setProperties()
        
        form +++ Section("General")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Enter event name"
            }
        
        form +++ Section("Date")
            <<< DateTimeRow(){
                $0.title = "Start Date"
                $0.value = Date(timeIntervalSinceReferenceDate: NSDate().timeIntervalSinceReferenceDate)
            }
            <<< DateTimeRow(){
                $0.title = "End Date"
                $0.value = Date(timeIntervalSinceReferenceDate: NSDate().timeIntervalSinceReferenceDate + 2000)
            }
        
        form +++ Section("Address")
            <<< PostalAddressRow() {
                $0.streetPlaceholder = "Street"
                $0.statePlaceholder = "State"
                $0.cityPlaceholder = "City"
                $0.postalCodePlaceholder = "Zip code"
            }
        
        form +++ Section("Contact")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Enter contact name"
            }
            <<< EmailRow(){ row in
                row.title = "Email"
                row.placeholder = "Enter contact email"
            }
            <<< PhoneRow(){ row in
                row.title = "Phone Number"
                row.placeholder = "Enter contact number"
            }
        
        form +++ Section("Details")
            <<< TextRow(){ row in
                row.title = "Event Details"
                row.placeholder = "Enter event details"
            }
        
        form +++ Section("Other")
            <<< URLRow(){ row in
                row.title = "Image URL"
                row.placeholder = "Enter event image URL"
            }
        
    }
    
    func setProperties() {
        animateScroll = true
        rowKeyboardSpacing = 20
    }
}
