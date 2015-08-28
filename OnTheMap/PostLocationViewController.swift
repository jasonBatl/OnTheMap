//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/7/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//
import Foundation
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
    
    //var location: CLLocation?
    var mapString: String = ""
    var activeStudent: StudentInformation?
    var errors: [NSError] = []
    
    var region: MKCoordinateRegion?
    
    @IBAction func cancelBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        //var tapGesture = UITapGestureRecognizer(target: self, action: "didTapTextContainer:")
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
        
        startActivity()
        var geoLocator = CLGeocoder()
        geoLocator.geocodeAddressString(locationTextField.text){ info, error in
            if let e = error {
                self.activityIndicator.hidden = true
                self.showErrorAlert("Location error", defaultMessage: "Could not find your location", errors: self.errors)
            } else {
                if let places = info as? [CLPlacemark]{
                    let coordinate = places[0].location.coordinate
                    let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
                    self.region = MKCoordinateRegion(center: coordinate, span: span)
                    self.MapView.setRegion(self.region!, animated: true)
                    self.submitBtn.enabled = true
                    
                    var dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinate
                    self.MapView.addAnnotation(dropPin)
                    
                    self.activityIndicator.hidden = true
                    self.urlTextField.hidden = false
                    self.submitBtn.hidden = false
                    self.directionsLabel.text = "Add your URL!"
                    self.locationTextField.hidden = true
                    self.findMeBtn.hidden = true
                }
            }
        }
            
        
    }
    
 
    
    func startActivity() {
        activityIndicator.startAnimating()
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? PinAnnotation {
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
        if urlTextField.text != nil {
                StudentLocation().POSTStudentInformation(buildInfo()) { (success, error) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func buildInfo() -> [String: AnyObject] {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            let hash: [String: AnyObject] = [
                "firstName": appDelegate.user!.firstName,
                "lastName": appDelegate.user!.lastName,
                "latitude": region!.center.latitude,
                "longitude": region!.center.longitude,
                "mapString": mapString,
                "mediaURL": urlTextField.text,
                "uniqueKey": appDelegate.user!.id
            ]
            return hash
        }
        return [:]
    }
    

}
