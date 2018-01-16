//
//  ContainerSearchController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ContainerSearchController: UIViewController {
    @IBOutlet weak var searchListContainerView: UIView!
    @IBOutlet weak var searchMapContainerView: UIView!
    
    var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return manager
    }()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMapContainerView.alpha = 0
        
        locationManager.delegate = self
        checkLocationServicesAuthorization()
    }
    
    @IBAction func changeContainerView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.searchListContainerView.alpha = 1
                self.searchMapContainerView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.searchListContainerView.alpha = 0
                self.searchMapContainerView.alpha = 1
            }
        }
    }
}

extension ContainerSearchController: CLLocationManagerDelegate {
    func checkLocationServicesAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        print("Current Location Set: \(currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServicesAuthorization()
    }
    
}











