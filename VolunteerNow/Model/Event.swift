//
//  Event.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import CoreLocation
import MapKit

class Event: NSObject, MKAnnotation {
    var name: String
    var organizer: String
    var startDate: Date?
    var endDate: Date?
    var location: String
    var distance: Double?
    var information: String?
    var coordinate: CLLocationCoordinate2D
    var link: String?
    var isSaved: Bool = false
    var eventID: Int?
    var imageString: String
    
    init(name: String, organizer: String, location: String, distance: Double, coordinate: CLLocationCoordinate2D, imageString: String) {
        self.name = name
        self.organizer = organizer
        self.location = location
        self.distance = distance
        self.coordinate = coordinate
        self.imageString = imageString
        super.init()
    }
    
    init?(data: [String: Any]) {
        guard let name = data["name"] as? String, let organizer = data["organizer"] as? String, let date = data["date"] as? String, let location = data["location"] as? String, let description = data["description"] as? String, let coordinate = data["coordinate"] as? [String: CLLocationDegrees], let link = data["link"] as? String, let eventID = data["eventID"] as? String, let imageString = data["imageString"] as? String else {
            return nil
        }
        
        self.name = name
        self.organizer = organizer
        self.location = location
        self.information = description
        self.link = link
        self.eventID = Int(eventID) ?? 0
        self.imageString = imageString
        guard let latitude = coordinate["latitude"], let longitude = coordinate["longitude"] else {
            return nil }
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if date.count > 10 {
            var index = date.index(date.startIndex, offsetBy:10)
            self.startDate = dateFormatter.date(from: date.substring(to: index))!
            
            index = date.index(date.startIndex, offsetBy:13)
            self.endDate = dateFormatter.date(from: date.substring(from: index))!
        } else {
            self.startDate = dateFormatter.date(from: date)!
        }
        
        super.init()
        
        Event.addEvent(self)
    }
}

enum SortType: String {
    case closest
    case upcoming
    case relevance
    case popularity
}

enum CategoryType: String {
    case all
    case children
    case seniors
    case animals
    case education
    case advocacy
}

extension Event {
    static var selectedSortType: SortType = .relevance
    static var selectedCategoryType: CategoryType = .all
    
    static var allEvents: [Event] = []
    static var selectedEvents: [Event] = []
    
    static func addEvent(_ event : Event) {
        allEvents.append(event)
        selectedEvents.append(event) // TODO: Remove this line
        updateSelectedEventsList()
    }
    
    static func updateSelectedEventsList() {
        print("Updated selected events based on category and sort")
    }
}




