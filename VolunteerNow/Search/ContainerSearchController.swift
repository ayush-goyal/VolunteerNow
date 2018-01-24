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
    
    var searchListController: SearchListCollectionViewController!
    var searchMapController: SearchMapController!
    
    var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return manager
    }()
    
    var currentLocation: CLLocation? {
        didSet {
            searchMapController.currentLocation = self.currentLocation
            App.shared.currentLocation = self.currentLocation
            searchListController.collectionView?.reloadData()
            
            //Event.setEventInDatabase(withId: "3939943", location: self.currentLocation!)
            Event.retrieveClosestEventsFromDatabase()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkLocationServicesAuthorization()
                
        searchMapContainerView.alpha = 0

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(filterList))
        
        addSelectorSegmentedView()
        addShadowToBar()
        addShadowToTabBar()
        changeBackNavigationButton()
        
    }
    
    func addSelectorSegmentedView() {
        let selectorSegmentedView = SelectorSegmentedView(normalColor: UIColor.Custom.lightGray, highlightColor: UIColor.Custom.purple, titles: ["List", "Map"], images: [#imageLiteral(resourceName: "list"),#imageLiteral(resourceName: "location")], selectedImages: [#imageLiteral(resourceName: "list_selected"), #imageLiteral(resourceName: "location_selected")],width: UIScreen.main.bounds.width, changeView: self.changeContainerView)
        selectorSegmentedView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(selectorSegmentedView)
        selectorSegmentedView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        selectorSegmentedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        selectorSegmentedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        selectorSegmentedView.heightAnchor.constraint(equalToConstant: 59).isActive = true
    }
    
    func changeContainerView(sender: SelectorSegmentedView) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.searchListContainerView.alpha = 1
                self.searchMapContainerView.alpha = 0
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openEventSearch))
        } else {
            UIView.animate(withDuration: 0.3) {
                self.searchListContainerView.alpha = 0
                self.searchMapContainerView.alpha = 1
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "CurrentLocation"), style: .plain, target: self, action: #selector(zoomMap))
        }
    }
    
    @objc func filterList() {
        if let navigationViewController = storyboard?.instantiateViewController(withIdentifier: "barFilterNavigationController") as? UINavigationController {
            present(navigationViewController, animated: true, completion: nil)
        }
    }
    
    @objc func zoomMap() {
        searchMapController.zoomMap()
    }
    
    @objc func openEventSearch() {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
            
        case let viewController as SearchListCollectionViewController:
            self.searchListController = viewController
            App.shared.searchListController = viewController
            
        case let viewController as SearchMapController:
            self.searchMapController = viewController
            App.shared.searchMapController = viewController
        
        default:
            break
        }
    }
    
    @IBAction func unwindToContainerSearchController(_ segue: UIStoryboardSegue) {
        
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
        print("Current Location Set: \(String(describing: currentLocation))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServicesAuthorization()
    }
    
}











