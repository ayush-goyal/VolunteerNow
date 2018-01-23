//
//  Organization.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/22/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import Foundation

struct Organization {
    static var upcomingEvents: [Event] = []
    static var completedEvents: [Event] = []
    
    static func retrieveEventsFromDatabase() {
        
    }
    
    private init(organizer: String, website: String) {
        self.organizer = organizer
        self.webste = website
    }
    
    static var shared: Organization!
    
    static func sharedInit(organizer: String, website: String) {
        Organization.shared = Organization(organizer: organizer, website: website)
    }
    
    var organizer: String
    
    var webste: String

}
