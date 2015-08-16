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
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? PinAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
    
    //save view
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        view.addGestureRecognizer(tapGesture)
        selectedView = view
    }
    
    //forget saved view
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        selectedView = nil
        view.removeGestureRecognizer(tapGesture)
    }
    
    //open url for saved view
    func tapped(sender: MapKitViewController) {
        if let studentInfo = selectedView!.annotation as? StudentInformation,
            let url = NSURL(string: studentInfo.mediaURL)
        {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    //center map
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000000, 2000000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    
}
