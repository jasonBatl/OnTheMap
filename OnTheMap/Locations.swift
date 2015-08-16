//
//  Locations.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/6/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation {
    
    //static var locations: [PinAnnotation] = []
    //static var errors: [NSError] = []
    
    func getRecentStudents(completionHandler: (pins: [StudentInformation]?, success:Bool, error: String?) -> Void) {
        var headers = APIHelper.buildHeaders()
        var getInfoRequest = APIHelper.getRequest(APIHelper.BaseURLs.MapAPI, api: APIHelper.APIs.StudentLocation, headers: headers, queryString: [String: String]())
        var task = APIHelper.buildTask(getInfoRequest){ (data, error) in
            if let e = error{
                completionHandler(pins: nil, success: false, error: "Could not get info from server")
            } else {
                let response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject]
                if let error = response!["error"] as? String{
                    completionHandler(pins: nil, success: false, error: error)
                } else {
                    var pins = [StudentInformation]()
                    var pinsJSON = response!["results"] as! [[String: AnyObject]]
                    for pinJSON in pinsJSON {
                        pins.append(self.buildPin(pinJSON))
                    }
                    completionHandler(pins: pins, success: true, error: nil)
                }
            }
        }
    }
    

    //Parse location data into StudentInformation
    func parseLocationData(body: [String: AnyObject], completionHandler: (success: Bool, error:String?) -> Void) {
        var headers = APIHelper.buildHeaders()
        var postInfoRequest = APIHelper.postRequest(APIHelper.BaseURLs.MapAPI, api: APIHelper.APIs.StudentLocation, body: body, headers: headers, queryString: [:])
        var task = APIHelper.buildTask(postInfoRequest) { (data, error) in
            if let e = error {
                completionHandler(success: false, error: "Could not get info from server")
            } else {
                let response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String: AnyObject]
                if let error = response!["error"] as? String{
                    completionHandler(success: false, error: error)
                } else {
                    completionHandler(success: true, error: nil)
                }
            }
        }
        
    }
    

    func buildPin(jsonResponse: [String: AnyObject]) -> StudentInformation {
        let pin = StudentInformation(dictionary: jsonResponse)
        return pin
    }
    
}