//
//  Event.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import CoreLocation
import MapKit
import GeoFire

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
    var title: String? {
        return self.name
    }
    let organizer: String
    
    let location: (latitude: Double, longitude: Double)
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude)
    }
    
    let address: Address
    
    var distance: Double? {
        let location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        if let distance = App.shared.currentLocation?.distance(from: location) {
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
    
    var date: Date // TODO: Date of first event - fix for onoing dates
    
    //var isSaved: Bool = false
    let id: Int
    
    init?(data: NSDictionary) {
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
            let imageUrl = data["imageUrl"] as? String,
            let id = data["id"] as? Int
        else { fatalError() }
        
        self.name = name
        self.organizer = organizer
        
        if let latitude = location["latitude"], let longitude = location["longitude"] {
            self.location = (latitude: latitude, longitude: longitude)
        } else { fatalError() }
        
        if let street = address["street"], let city = address["city"], let state = address["state"], let zip = address["zip"] {
            self.address = Address(street: street, city: city, state: state, zip: zip)
        } else { fatalError() }
        
        if let description = details["description"], let organizer = details["organizer"], let setting = details["setting"], let ages = details["ages"] {
            self.details = Details(description: description, organizer: organizer, setting: setting, ages: ages)
        } else { fatalError() }
        
        if let name = contact["name"], let email = contact["email"], let phone = contact["phone"] {
            self.contact = Contact(name: name, email: email, phone: phone)
        } else { fatalError() }
            
        self.website = website
        self.tags = tags
        self.imageUrl = imageUrl
        self.id = id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        
        if type == "ongoing" {
            self.type = .ongoing
            self.date = dateFormatter.date(from: "2018-01-30 23:22:35 +0000")! // TODO: Fix this line for ongoing events
        } else if type == "once" {
            guard
                let startDateString = data["startDate"] as? String,
                let startDate = dateFormatter.date(from: startDateString),
                let endDateString = data["endDate"] as? String,
                let endDate = dateFormatter.date(from: endDateString)
            else { fatalError() }
            
            self.type = .once(startDate: startDate, endDate: endDate)
            self.date = startDate
        } else {
            fatalError()
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
    
    var print: String {
        return street + "\n" + city + ", " + state + ", " + zip
    }
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

enum DistanceType: Double {
    case five = 5
    case ten = 10
    case twenty = 20
    case thirty = 30
}


enum SortType: String {
    case closest
    case upcoming
    case relevance
    case popularity
}

enum CategoryType: String {
    case children
    case seniors
    case animals
    case education
    case advocacy
}

extension Event {
    static var selectedSortType: SortType = .relevance
    static var selectedCategoryType: [CategoryType] = [.children, .seniors, .animals, .education, .advocacy]
    static var selectedDistanceType: DistanceType = .ten
    
    static var allEvents: [Event] = []
    static var selectedEvents: [Event] = []
    static var loadedEventIds: [String] = []
    
    static func addEvent(_ event : Event) {
        allEvents.append(event)
        //selectedEvents.append(event) // TODO: Remove this line
    }
    
    static func updateSelectedEventsList() {
        print("Updated selected events based on category and sort")
        var events: [Event] = []
        for event in allEvents {
            if let distance = event.distance {
                if distance <= Event.selectedDistanceType.rawValue {
                    switch event.type {
                    case .ongoing:
                        events.append(event)
                    case .once(let startDate, let endDate):
                        if startDate < Date() {
                            break
                        } else {
                            events.append(event)
                        }
                    }
                }
            }
        }
        switch Event.selectedSortType {
        case .closest:
            events = events.sorted(by: { $0.distance! < $1.distance! })
            break
        case .upcoming:
            events = events.sorted(by: { $0.date < $1.date })
            break
        default:
            break
        }
        Event.selectedEvents = events
    }
}


extension Event {
    static func setEventLocationInDatabase(withId eventId: String, location: CLLocation) {
        let geoFire = GeoFire(firebaseRef: App.shared.dbRef.child("event-locations"))!
        geoFire.setLocation(location, forKey: eventId) { (error) in
            if let error = error {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully to GeoFire")
            }
        }
    }
    
    static func setEventLocationsForEventsInDatabase() {
        App.shared.dbRef.child("events").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as! [String: [String: Any]]
            for (key, event) in value {
                let location = event["location"] as! [String: Double]
                let clLocation = CLLocation(latitude: location["latitude"]!, longitude: location["longitude"]!)
                setEventLocationInDatabase(withId: key, location: clLocation)
            }
        }
    }
    
    static func retrieveClosestEventsFromDatabase() {
        guard let currentLocation = App.shared.currentLocation else { return }
        let geoFire = GeoFire(firebaseRef: App.shared.dbRef.child("event-locations"))!
        // Query locations at currentLocation with a radius of km
        let center = currentLocation
        print("\n" + String(Event.selectedDistanceType.rawValue))
        let geoQuery = geoFire.query(at: center, withRadius:
            Double(Event.selectedDistanceType.rawValue) * 1.609)
        
        var events: [String] = []
        
        geoQuery?.observe(.keyEntered) { key, location in
            guard let key = key, let location = location else { fatalError() }
            print("\nKey '\(key)' entered the search area and is at location '\(location)'")
            events.append(key)
        }
        
        geoQuery?.observeReady {
            let group = DispatchGroup()
            
            for key in events {
                if !Event.loadedEventIds.contains(key) { // Checks if key has already been loaded
                    Event.loadedEventIds.append(key)
                    group.enter()
                    App.shared.dbRef.child("events").child(key).observeSingleEvent(of: .value) { snapshot in
                        let value = snapshot.value as! NSDictionary
                        Event(data: value)
                        group.leave()
                    }
                }
            }
            // We ask to be notified when every block left the group
            group.notify(queue: .main) {
                print("All events loaded")
                App.shared.reloadSearchData()
            }
            
        }
        
    }
    
    static func retrieveEventsFromDatabase(keys: NSArray, completionHandler: @escaping ([Event]) -> Void) {
        let group = DispatchGroup()
        var events: [Event] = []
        for key in keys {
            let key = String(describing: key)
            if !Event.loadedEventIds.contains(key) { // Checks if key has already been loaded
                group.enter()
                App.shared.dbRef.child("events").child(key).observeSingleEvent(of: .value) { snapshot in
                    let value = snapshot.value as! NSDictionary
                    Event.loadedEventIds.append(key)
                    events.append(Event(data: value)!)
                    group.leave()
                }
            } else {
                events.append(allEvents[loadedEventIds.index(of: key)!])
            }
        }
        // We ask to be notified when every block left the group
        group.notify(queue: .main) {
            print("All events loaded")
            completionHandler(events)
        }
    }
}


/*Event(data: [
 "name": "Day Field Trip for Children to the College Football Hall of Fame",
 "organizer": "Acworth Parks, Recreation, and Community Resource Department",
 "location": [
 "latitude": 37.540902,
 "longitude": -122.047119
 ],
 "address": [
 "street": "3279 Yorktown Dr",
 "city": "Roswell",
 "state": "GA",
 "zip": "30075"
 ],
 "details": [
 "description": "Volunteers are needed to clean, build crate-shelves, catalogue artifacts, and inventory exhibits at the Sights & Sounds Black Cultural Museum.",
 "organizer": "Generation 180 is dedicated to driving a cultural shift in energy awareness and advancing the transition to clean energy. The organization is looking for volunteers to support its clean energy campaigns. The Generation 180 volunteer teams will build community support and advocate for local schools to go solar, lead workshops that encourage community members to adopt clean energy solutions, and encourage businesses to stop energy waste. Generation 180 is committed to empowering each volunteer team with ongoing training, education, and support to be effective in making positive changes in your community. We are looking for motivated individuals to assist in both forming and leading a new Generation 180 team in your community. ",
 "setting": "Indoor",
 "ages": "12+",
 ],
 "contact": [
 "name": "John Stewart",
 "email": "john@gmail.com",
 "phone": "678-343-9933"
 ],
 "website": "k",
 "tags": ["kids", "group", "elderly"],
 "imageUrl": "http://www.nyrr.org/sites/default/files/styles/rfl-testimonial-712x385/public/nyrr-photo-album/2016/2016SpringSummerVolunteers_04.JPG?itok=WAE6XwRJ",
 "type": "once",
 "startDate": "2018-01-18 22:22:35 +0000",
 "endDate": "2018-01-18 23:22:35 +0000"
 ])*/

