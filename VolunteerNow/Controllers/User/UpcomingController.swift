//
//  UpcomingController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/15/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

private let eventCellReuseIdentifier = "eventId"

class UpcomingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.Custom.purple
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = collectionView {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // Register cell classes
        self.collectionView!.register(EventCell.self, forCellWithReuseIdentifier: eventCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.Custom.backgroundGray
        
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.addSubview(refresher)
    }
    
    @objc func loadData() {
        App.User.retrieveEventsFromDatabase(withKey: .upcoming, collectionView: self.collectionView!, refresher: self.refresher)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return App.User.upcomingEvents.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCell
        let event = App.User.upcomingEvents[indexPath.row]
        
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
            viewController.event = Event.selectedEvents[indexPath.row]
            viewController.setValues()
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
}
