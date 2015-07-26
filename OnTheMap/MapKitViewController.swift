//
//  MapKitViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/1/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: LocationViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedView: MKAnnotationView?
    var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
        loadLocationData() {
            self.loadAnnotations()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRefreshLocationData", name: refreshNotification, object: nil)
    }

    func didRefreshLocationData() {
        self.mapView.removeAnnotations(StudentLocation.locations)
        self.loadAnnotations()
    }
    
    //add annotations
    func loadAnnotations() {
        let coord = StudentLocation.locations[0].coordinate
        let initialLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        centerMapOnLocation(initialLocation)
        for location in StudentLocation.locations {
            mapView.addAnnotation(location)
        }
    }
    
    //center map
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000000, 2000000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    
}
