//
//  Event.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import CoreLocation
import MapKit

/*
{
    name: String,
    organizer: String,
    location: {
        latitude: Double,
        longitude: Double
    },
    address: {
        street: String,
        city: String,
        state: String,
        zip: String
    },
    details: {
        description: String,
        organizer: String,
        setting: String,
        ages: String,
    },
    contact: {
        name: String,
        email: String,
        phone: String
    },
    website: String,
    tags: [String],
    imageUrl: String,
    type: String (ongoing, once),
    startDate: "yyyy-MM-dd HH:mm:ss ZZZ",
    endDate: "yyyy-MM-dd HH:mm:ss ZZZ",
 
}
*/

class Event: NSObject, MKAnnotation {
    let name: String
    let organizer: String
    
    static var currentLocation: CLLocation?
    
    let location: (latitude: Double, longitude: Double)
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude)
    }
    
    let address: Address
    
    var distance: Double? {
        let location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        if let distance = Event.currentLocation?.distance(from: location) {
            let distanceInMiles = (distance * 10/1609.34).rounded() / 10.0 // Gives one decimal point precision
            return distanceInMiles
        } else {
            return nil
        }
    }
    
    let details: Details
    let website: String
    let tags: [String]
    let imageUrl: String
    let contact: Contact
    let type: EventType
   
    
    //var isSaved: Bool = false
    //var eventID: Int?
    
    init?(data: [String: Any]) {
        guard
            let name = data["name"] as? String,
            let organizer = data["organizer"] as? String,
            let location = data["location"] as? [String: Double],
            let address = data["address"] as? [String: String],
            let details = data["details"] as? [String: String],
            let contact = data["contact"] as? [String: String],
            let website = data["website"] as? String,
            let tags = data["tags"] as? [String],
            let type = data["type"] as? String,
            let imageUrl = data["imageUrl"] as? String
        else { return nil }
        
        self.name = name
        self.organizer = organizer
        
        if let latitude = location["latitude"], let longitude = location["longitude"] {
            self.location = (latitude: latitude, longitude: longitude)
        } else { return nil }
        
        if let street = address["street"], let city = address["city"], let state = address["state"], let zip = address["zip"] {
            self.address = Address(street: street, city: city, state: state, zip: zip)
        } else { return nil }
        
        if let description = details["description"], let organizer = details["organizer"], let setting = details["setting"], let ages = details["ages"] {
            self.details = Details(description: description, organizer: organizer, setting: setting, ages: ages)
        } else { return nil }
        
        if let name = contact["name"], let email = contact["email"], let phone = contact["phone"] {
            self.contact = Contact(name: name, email: email, phone: phone)
        } else { return nil }
            
        self.website = website
        self.tags = tags
        self.imageUrl = imageUrl
        
        if type == "ongoing" {
            self.type = .ongoing
        } else if type == "once" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            
            guard
                let startDateString = data["startDate"] as? String,
                let startDate = dateFormatter.date(from: startDateString),
                let endDateString = data["endDate"] as? String,
                let endDate = dateFormatter.date(from: endDateString)
            else { return nil }
            
            self.type = .once(startDate: startDate, endDate: endDate)
        } else {
            return nil
        }
        
        super.init()
        
        Event.addEvent(self)
    }
}

struct Address {
    var street: String
    var city: String
    var state: String
    var zip: String
}

struct Details {
    var description: String
    var organizer: String
    var setting: String
    var ages: String
}

enum EventType {
    case ongoing
    case once(startDate: Date, endDate: Date)
}

struct Contact {
    var name: String
    var email: String
    var phone: String
}



/*
 
 
 Event.addEvent(Event(name: "Day Field Trip for Children to the College Football Hall of Fame", organizer: "Acworth Parks, Recreation, and Community Resource Department", location: "3279 Yorktown Dr", distance: 34, coordinate: CLLocationCoordinate2DMake(34.43532, 32.53423), imageString: "http://www.nyrr.org/sites/default/files/styles/rfl-testimonial-712x385/public/nyrr-photo-album/2016/2016SpringSummerVolunteers_04.JPG?itok=WAE6XwRJ"))
 Event.addEvent(Event(name: "Volunteer for Pets", organizer: "PetVolunteer", location: "3279 Yorktown Dr", distance: 34, coordinate: CLLocationCoordinate2DMake(34.43532, 32.53423), imageString: "https://www.tcsnycmarathon.org/sites/default/files/styles/image-705x400/public/TCSNYCM14_volunteer%20race%20day%20story.jpg?itok=ZJqnqueH"))
 Event.addEvent(Event(name: "Volunteer for Pets", organizer: "PetVolunteer", location: "3279 Yorktown Dr", distance: 34, coordinate: CLLocationCoordinate2DMake(34.43532, 32.53423), imageString: "https://www.tcsnycmarathon.org/sites/default/files/styles/image-705x400/public/TCSNYCM14_volunteer%20race%20day%20story.jpg?itok=ZJqnqueH"))
 
 
 */






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




