//
//  SearchListCollectionViewController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/15/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import CoreLocation

private let eventCellReuseIdentifier = "eventId"

class SearchListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(EventCell.self, forCellWithReuseIdentifier: eventCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.Custom.backgroundGray

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Event.selectedEvents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCell
        let event = Event.selectedEvents[indexPath.row]

        cell.nameLabel.text = event.name
        cell.organizerLabel.text = event.organizer
        cell.distanceLabel.text = String(event.distance!)
        switch event.type {
        case .ongoing:
            cell.dateLabel.text = "Ongoing Event"
        case .once(let startDate, let endDate):
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM DD"
            cell.dateLabel.text = formatter.string(from: startDate)
        }
        cell.backgroundImageView.downloadedFrom(link: event.imageUrl)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width-20, height: 200) // Subtract left and right collection view section insets
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
