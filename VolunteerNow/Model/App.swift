//
//  App.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/18/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

struct App {
    
    private init() {
        
    }
    
    static var shared = App()
    
    var currentLocation: CLLocation?
    var dbRef: DatabaseReference!
    
    var searchListController: SearchListController!
    var searchMapController: SearchMapController!
    
    func reloadSearchData() {
        searchMapController.removeAnnotations()
        
        Event.updateSelectedEventsList()
        searchListController.collectionView?.reloadData()
        searchListController.stopRefresher()
        searchMapController.addAnnotations()
        
    }
    
    static func snapshotToEvents(snapshot: DataSnapshot, completionHandler: @escaping ([Event]) -> Void) {
        if let value = snapshot.value as? NSArray {
            Event.retrieveEventsFromDatabase(keys: value) { events in
                completionHandler(events)
            }
        } else {
            completionHandler([])
        }
    }
    
    enum DatabaseDirectory: String {
        case upcoming
        case completed
    }
    
    struct User {
        static var upcomingEvents: [Event] = []
        static var completedEvents: [Event] = []
        
        static func retrieveEventsFromDatabase(withKey key: DatabaseDirectory, collectionView: UICollectionView, refresher: UIRefreshControl?) {
            App.shared.dbRef.child("users").child(User.uid).child(key.rawValue).observeSingleEvent(of: .value) { snapshot in
                snapshotToEvents(snapshot: snapshot) { array in
                    switch key {
                    case .upcoming:
                        User.upcomingEvents = array
                        break
                    case .completed:
                        User.completedEvents = array
                        break
                    }

                    collectionView.reloadData()
                    if let refresher = refresher {
                        refresher.endRefreshing()
                    }
                }
            }
        }
        
        static var name: String!
        static var email: String!
        static var uid: String!
        static var fcmToken: String?
    }
    
    struct Organization {
        static var upcomingEvents: [Event] = []
        static var completedEvents: [Event] = []
        
        static func retrieveEventsFromDatabase(withKey key: DatabaseDirectory, collectionView: UICollectionView, refresher: UIRefreshControl?) {
            App.shared.dbRef.child("organizations").child(Organization.id).child(key.rawValue).observeSingleEvent(of: .value) { snapshot in
                snapshotToEvents(snapshot: snapshot) { array in
                    switch key {
                    case .upcoming:
                        Organization.upcomingEvents = array
                        break
                    case .completed:
                        Organization.completedEvents = array
                        break
                    }
                    
                    collectionView.reloadData()
                    if let refresher = refresher {
                        refresher.endRefreshing()
                    }
                }
            }
        }
        
        static var organizer: String!
        static var webste: String!
        static var id: String!
    }
}
