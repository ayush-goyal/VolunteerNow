//
//  Organization.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/22/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

struct Organization {
    static var upcomingEvents: [Event] = []
    static var completedEvents: [Event] = []
    
    static func retrieveUpcomingEventsFromDatabase(collectionView: UICollectionView, refresher: UIRefreshControl?) {
        App.shared.dbRef.child("organizations").child(id).child("upcoming").observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? NSArray {
                Event.retrieveEventsFromDatabase(keys: value) { events in
                    self.upcomingEvents = events
                    collectionView.reloadData()
                    if let refresher = refresher {
                        refresher.endRefreshing()
                    }
                }
            }
        }
    }
    static func retrieveCompletedEventsFromDatabase(collectionView: UICollectionView, refresher: UIRefreshControl?) {
        App.shared.dbRef.child("organizations").child(id).child("completed").observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? NSArray {
                Event.retrieveEventsFromDatabase(keys: value) { events in
                    self.completedEvents = events
                    collectionView.reloadData()
                    if let refresher = refresher {
                        refresher.endRefreshing()
                    }
                }
            }
        }
    }
    
    static var organizer: String!
    static var webste: String!
    static var id: String!
}
