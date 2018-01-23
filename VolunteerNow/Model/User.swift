//
//  User.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/22/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import Foundation

struct User {
    static var upcomingEvents: [Event] = []
    static var completedEvents: [Event] = []
    
    static func retrieveEventsFromDatabase() {
    }
    
    static var name: String!
    static var email: String!
    static var uid: String!
}

