//
//  MapKitViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/1/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapKitViewController: TabViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            
            let infoButton = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
            infoButton.setImage(UIImage(named: "info"), forState: .Normal)
            
            pinAnnotationView.leftCalloutAccessoryView = infoButton
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        goToURL(view.annotation.subtitle!)
    }
    
    override func useInfo(){
        for info in studentInformations{
            var location = CLLocationCoordinate2DMake(info.latitude, info.longitude)
            // Drop a pindrop
            var dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            dropPin.title = info.mapString
            dropPin.subtitle = info.mediaURL
            mapView.addAnnotation(dropPin)
            
        }
        
    }
    
     

    
}
