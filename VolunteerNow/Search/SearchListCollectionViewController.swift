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

        Event.addEvent(Event(name: "Volunteer for pets", organizer: "PetVolunteer", location: "3279 Yorktown Dr", distance: 34, coordinate: CLLocationCoordinate2DMake(34.43532, 32.53423), imageString: "http://www.nyrr.org/sites/default/files/styles/rfl-testimonial-712x385/public/nyrr-photo-album/2016/2016SpringSummerVolunteers_04.JPG?itok=WAE6XwRJ"))
        Event.addEvent(Event(name: "Volunteer for pets", organizer: "PetVolunteer", location: "3279 Yorktown Dr", distance: 34, coordinate: CLLocationCoordinate2DMake(34.43532, 32.53423), imageString: "https://www.tcsnycmarathon.org/sites/default/files/styles/image-705x400/public/TCSNYCM14_volunteer%20race%20day%20story.jpg?itok=ZJqnqueH"))

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
        cell.dateLabel.text = String(describing: event.startDate)
        cell.backgroundImageView.downloadedFrom(link: event.imageString)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width-20, height: 200) // Subtract left and right collection view section insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 0, 10)
    }

}
