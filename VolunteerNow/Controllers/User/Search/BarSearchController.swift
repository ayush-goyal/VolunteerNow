//
//  BarSearchController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/16/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

private let eventCellReuseIdentifier = "eventId"

class BarSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var shouldShowSearchResults = false
    var filteredEvents: [Event] = Event.selectedEvents
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(EventCell.self, forCellWithReuseIdentifier: eventCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.Custom.backgroundGray
        
        self.collectionView?.alwaysBounceVertical = true
        
        addShadowToBar()
        addShadowToTabBar()

        configureSearchController()
    }
    
    func configureSearchController() {
        searchBar = UISearchBar()
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Search events"
        
        self.navigationItem.titleView = searchBar
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldShowSearchResults{
            return filteredEvents.count
        } else {
            return Event.selectedEvents.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCell
        
        var event: Event
        if shouldShowSearchResults{
            event = filteredEvents[indexPath.row]
        } else {
            event = Event.selectedEvents[indexPath.row]
        }
        
        cell.setEventProperties(event: event)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width-20, height: 220) // Subtract left and right collection view section insets
        // Also change size of image tint view in extensions if cell size changed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigator = navigationController {
            let viewController = EventDetailController()
            viewController.setValues(withEvent: Event.selectedEvents[indexPath.row])
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
}

extension BarSearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        collectionView?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        collectionView?.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filteredEvents = Event.selectedEvents.filter { event in
                return event.name.lowercased().contains(searchText.lowercased())
            }
            
        }
        if searchBar.text == "" {
            filteredEvents = Event.selectedEvents
        }
        
        self.collectionView?.reloadData()
    }
}

