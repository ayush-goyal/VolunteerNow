//
//  SearchListController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/*class SearchListController: UITableViewController {
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Event.addEvent(Event(name: "Volunteer for pets", organizer: "PetVolunteer", location: "3279 Yorktown Dr", distance: 34, coordinate: CLLocationCoordinate2DMake(34.43532, 32.53423), imageString: "http://www.nyrr.org/sites/default/files/styles/rfl-testimonial-712x385/public/nyrr-photo-album/2016/2016SpringSummerVolunteers_04.JPG?itok=WAE6XwRJ"))
        Event.addEvent(Event(name: "Volunteer for pets", organizer: "PetVolunteer", location: "3279 Yorktown Dr", distance: 34, coordinate: CLLocationCoordinate2DMake(34.43532, 32.53423), imageString: "https://www.tcsnycmarathon.org/sites/default/files/styles/image-705x400/public/TCSNYCM14_volunteer%20race%20day%20story.jpg?itok=ZJqnqueH"))
        
        tableView.register(EventCell.self, forCellReuseIdentifier: "cellId")
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Event.selectedEvents.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! EventCell
        let event = Event.selectedEvents[indexPath.row]
        
        cell.nameLabel.text = event.name
        cell.organizerLabel.text = event.organizer
        cell.distanceLabel.text = String(event.distance!)
        cell.dateLabel.text = String(describing: event.startDate)
        cell.backgroundImageView.downloadedFrom(link: event.imageString)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Row selected: \(indexPath)")
        return nil
    }
}
*/
