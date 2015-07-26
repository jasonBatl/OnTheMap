//
//  Locations.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/6/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation

class StudentLocation {
    
    static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static var locations: [StudentInformation] = []
    static var errors: [NSError] = []
    
    
    //gets posted study locations w/o making a request
    class func getRecent(forceRefresh: Bool = true, didComplete: (success: Bool) -> Void) {
        if forceRefresh || locations.isEmpty {
            locations = []
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-createdAt")!)
            request.addValue(StudentLocation.appId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(StudentLocation.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = NSURLSession.sharedSession()
            
            //make the request
            let task = session.dataTaskWithRequest(request) { data, response, error in
                
                if error != nil {
                    self.errors.append(error)
                    didComplete(success: false)
                    return
                }
                let success = StudentLocation.parseLocationData(data)
                didComplete(success: success)
                
            }
            task.resume()
        }
        else if !locations.isEmpty {
            didComplete(success: true)
        }
    }
    
    
    //Parse location data into StudentInformation
    class func parseLocationData(data: NSData) -> Bool {
        var success = false
        if let locationData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? NSDictionary {
            if let data = locationData["results"] as? [NSDictionary] {
                success = true
                for studentInfo in data {
                    if !StudentInformation.isValidData(studentInfo) {
                        success = false
                        break
                    }
                    locations.append(StudentInformation(data: studentInfo))
                }
            }
        }
        if !success {
            errors.append(NSError(domain: "Location data error parsing", code: 1, userInfo: nil))
        }
        return success
        
    }
    
    //Store new location in the db with POST method
    class func newLocation(latitude: Double, longitude: Double, mediaURL: String, mapString: String, didComplete: (success: Bool) -> Void) {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(StudentLocation.appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(StudentLocation.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyString = "{\"uniqueKey\": \"\(Users.key)\", \"firstName\": \"\(Users.firstName)\", \"lastName\": \"\(Users.lastName)\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errors.append(error)
                didComplete(success: false)
                return
            }
            didComplete(success: true)
        }
        task.resume()
    }
}