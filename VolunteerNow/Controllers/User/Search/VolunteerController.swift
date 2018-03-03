//
//  VolunteerController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/22/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import EventKit

class VolunteerController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    var event: Event!
    var eventId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar()
        addShadowToTabBar()
        
        navigationItem.title = "Volunteer"
        
        returnButton.layer.cornerRadius = 5
        returnButton.layer.masksToBounds = true
        
    }
    
    func setEventToFirebase() {
        App.shared.dbRef.child("users").child(App.User.uid).observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? NSDictionary {
                if var upcoming = value["upcoming"] as? [Int] {
                    upcoming.append(self.eventId)
                    App.shared.dbRef.child("users/\(App.User.uid!)/upcoming").setValue(NSArray(array: upcoming))
                } else {
                    App.shared.dbRef.child("users/\(App.User.uid!)/upcoming").setValue(NSArray(array: [self.eventId]))
                }
            } else {
                App.shared.dbRef.child("users/\(App.User.uid!)/upcoming").setValue(NSArray(array: [self.eventId]))
            }
        }
    }

    @IBAction func popToContainerSearchController(_ sender: Any) {
        performSegue(withIdentifier: "volunteerControllerUnwind", sender: self)
    }
    
    @IBAction func addEventToCalendar(_ sender: Any) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            if (granted && error == nil) {
                let calendarEvent = EKEvent(eventStore: eventStore)
                calendarEvent.title = self.event.name
                calendarEvent.notes = String(self.eventId)
                calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
                switch self.event.type {
                case .once(startDate: let startDate, endDate: let endDate):
                    calendarEvent.startDate = startDate
                    calendarEvent.endDate = endDate
                    break
                case .ongoing:
                    calendarEvent.startDate = self.event.date
                    calendarEvent.endDate = self.event.date // TODO: FIX THIS END DATE
                }
                print("Save event to calendar")
                do {
                    try eventStore.save(calendarEvent, span: .thisEvent)
                    DispatchQueue.main.async {
                        Popup.presentError(text: "Event saved to calendar", viewController: self.tabBarController, title: "Success")
                    }
                } catch {
                    DispatchQueue.main.async {
                        Popup.presentError(text: error.localizedDescription, viewController: self)
                    }
                }
                
            } else {
                Popup.presentError(text: error?.localizedDescription ?? "Error getting calendar access", viewController: self)
            }
        }
    }
}
