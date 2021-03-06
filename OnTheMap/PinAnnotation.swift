//
//  PinAnnotation.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/29/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }

}
