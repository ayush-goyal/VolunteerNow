//
//  SearchMapController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class SearchMapController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var currentLocation: CLLocation? {
        didSet {
            zoomMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    
    func zoomMap() {
        if let currentLocation: CLLocation = self.currentLocation {
            let viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), 8000, 8000)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    /*func addAnnotations() {
        mapView.addAnnotations(eventsData)
    }*/
    
}


/*extension SearchMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "event"
        var annotationView: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = infoButton
            //annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let event = view.annotation as? Event else { return }
        
        if let eventDetailController = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailController") as? EventDetailController {
            eventDetailController.event = event
            eventDetailController.managedObjectContext = managedObjectContext
            //present(eventDetailController, animated: true, completion: nil)
            navigationController?.pushViewController(eventDetailController, animated: true)
        }
    }
}*/
