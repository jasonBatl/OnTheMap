//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/7/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: ErrorAlertViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var findMeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var location: CLLocation?
    var mapString: String = ""
    
    
    @IBAction func cancelBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        var tapGesture = UITapGestureRecognizer(target: self, action: "didTapTextContainer:")
        locationTextField.delegate = self
        urlTextField.delegate = self
        
    //hide elements until needed
        activityIndicator.hidden = true
        urlTextField.hidden = true
        submitBtn.hidden = true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func didTapTextContainer(sender: AnyObject) {
        urlTextField.becomeFirstResponder()
    }

    
    @IBAction func findMePressed(sender: UIButton) {
        
        let text = locationTextField.text
        if !text.isEmpty {
            
            startActivity()
            var geoLocator = CLGeocoder()
            geoLocator.geocodeAddressString(text, completionHandler: didCompleteGeolocating)
            
        }
    }
    
    //Geolocating completion
    func didCompleteGeolocating(placemarks: [AnyObject]!, error: NSError!) {
        stopActivity()
        
        if error == nil && placemarks.count > 0 {
            
            //set the pin
            let placemark = placemarks[0] as! CLPlacemark
            let geoLocation = placemark.location!
            centerMapOnLocation(geoLocation)
            
            var studentInfo = StudentInformation(data: [
                "firstName": Users.firstName,
                "lastName": Users.lastName,
                "latitude": geoLocation.coordinate.latitude,
                "longitude": geoLocation.coordinate.longitude,
                "mediaURL": ""
                ])
            MapView.addAnnotation(studentInfo)
            urlTextField.hidden = false
            submitBtn.hidden = false
            directionsLabel.text = "Add your URL!"
            locationTextField.hidden = true
            findMeBtn.hidden = true
            
            
            mapString = locationTextField.text
            location = geoLocation
        } else {
            
            //Show error to user indicating the post failed
            showErrorAlert("Error Geolocating", defaultMessage: "Could not find location", errors: [error])
        }
    }
    
    
    func startActivity() {
        activityIndicator.startAnimating()
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? StudentInformation {
            let identifier  = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = MapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
            }
            return view
        }
        return nil
    }
    
    @IBAction func submitBtnPressed(sender: UIButton) {
        if !urlTextField.text.isEmpty && location != nil {
            let coord = location!.coordinate
            let text = urlTextField.text
            StudentLocation.newLocation(coord.latitude, longitude: coord.longitude, mediaURL: text, mapString: mapString) { success in
                    self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    

    //Centers map on a location from raywenderlich.com
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 20000, 20000)
        MapView.setRegion(coordinateRegion, animated: true)
    }

}
