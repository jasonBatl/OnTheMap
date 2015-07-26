//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/6/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation
import MapKit

class StudentInformation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var firstName: String
    var lastName: String
    var mediaURL: String
    
    var title: String
    var subtitle: String
    
    init(data: NSDictionary) {
        coordinate = CLLocationCoordinate2D( latitude: data["latitude"] as! Double, longitude: data["longitude"] as! Double)
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        mediaURL = data["mediaURL"] as! String
        
        title = "\(firstName) \(lastName)"
        subtitle = mediaURL
    }
    
    class func isValidData(data: NSDictionary) -> Bool {
        if let latitude = data["latitude"] as? Double,
            let longitude = data["longitude"] as? Double,
            let firstName = data["firstName"] as? String,
            let lastName = data["lastName"] as? String,
            let mediaUrl = data["mediaURL"] as? String
        {
            return true
        }
        return false
    }
}
