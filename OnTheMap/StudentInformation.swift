//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/6/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation


struct StudentInformation {
    var firstName = ""
    var lastName = ""
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var mediaURL = "Google.com"
    var objectID = ""
    var uniqueKey = ""
    
    init(dictionary: [String: AnyObject]){
        if let first = dictionary["firstName"] as? String {
            firstName = first
        }
        if let last = dictionary["lastName"] as? String {
            lastName = last
        }
        if let lat = dictionary["latitude"] as? Double {
            latitude = lat
        }
        if let long = dictionary["longitude"] as? Double {
            longitude = long
        }
        if let location = dictionary["mapString"] as? String {
            mapString = location
        }
        if let url = dictionary["mediaURL"] as? String {
            mediaURL = url
        }
        if let id = dictionary["objectID"] as? String {
            objectID = id
        }
        if let key = dictionary["uniqueKey"] as? String {
            uniqueKey = key
        }
    }
}