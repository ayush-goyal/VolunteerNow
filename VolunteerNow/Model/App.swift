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
import Presentr

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
    static func presentrError(text: String, viewController: UIViewController) {
        let presentr = Presentr(presentationType: .alert)
        presentr.presentationType = .alert
        
        /*let animation = CoverVerticalAnimation(options: .spring(duration: 1.0,
                                                                delay: 0,
                                                                damping: 0.7,
                                                                velocity: 0))
        let coverVerticalWithSpring = TransitionType.custom(animation)
        presentr.transitionType = coverVerticalWithSpring
        presentr.dismissTransitionType = coverVerticalWithSpring
        presentr.backgroundOpacity = 0.5
        presentr.dismissOnSwipe = true
        presentr.dismissOnSwipeDirection = .top*/
        
        let alertController = Presentr.alertViewController(title: "Error", body: text)
        let okAction = AlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        viewController.customPresentViewController(presentr, viewController: alertController, animated: true, completion: nil)
    }
}
