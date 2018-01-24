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
    
    var searchListController: SearchListCollectionViewController!
    var searchMapController: SearchMapController!
    
    func reloadSearchData() {
        searchMapController.removeAnnotations()
        
        Event.updateSelectedEventsList()
        searchListController.collectionView?.reloadData()
        searchListController.stopRefresher()
        searchMapController.addAnnotations()
        
    }
}
