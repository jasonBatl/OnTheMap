//
//  APIHelper.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 8/7/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation

class APIHelper {
    struct MapKeys {
        static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    static let JSON = "application/JSON"
    static let session = NSURLSession.sharedSession()
    
    struct BaseURLs {
        static let MapAPI = "https://api.parse.com/"
        static let Login = "https://www.udacity.com/"
    }
    
    struct APIs {
        static let StudentLocation = "1/classes/StudentLocation"
        static let Session = "api/session"
        static let UserData = "api/users/{id}"
    }
    
    static func buildTask(request: NSMutableURLRequest, completionHandler: (result: NSData!, error: NSError?) -> Void) -> NSURLSessionDataTask{
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                completionHandler(result: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    static func getRequest(baseUrl: String, api: String, headers: [String: String], queryString: [String: String]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: buildURLAndQueryString(baseUrl, api: api, queryString: queryString))
        request.addValue(JSON, forHTTPHeaderField: "Accept")
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    static func postRequest(baseUrl: String, api: String, body: [String: AnyObject], headers: [String: String], queryString: [String: String]) -> NSMutableURLRequest {
        var jsonifyError: NSError? = nil
        let request = getRequest(baseUrl, api: api, headers: headers, queryString: queryString)
        
        request.HTTPMethod = "POST"
        request.addValue(JSON, forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &jsonifyError)
        request.timeoutInterval = 10;
        
        return request
    }
    
    static func buildURLAndQueryString(baseUrl: String, api:String, queryString: [String: String]) -> NSURL {
        var url = NSURL(string: baseUrl + api + escapedParameters(queryString))
        
        return url!
    }
    
    static func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    
    static func buildHeaders() -> [String: String] {
        return [
            "X-Parse-Application-Id": MapKeys.appId,
            "X-Parse-REST-API-Key": MapKeys.apiKey
        ]
    }
}