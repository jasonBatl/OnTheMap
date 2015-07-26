//
//  users.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 6/23/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation
import UIKit


class Users {
    
    static var username = ""
    
    static var sessionId = ""
    
    static var errors: [NSError] = []
    
    static var key = ""
    
    static var loading = true
    
    static var firstName = ""
    static var lastName = ""
    
    
    class func login(username: String, password: String, didComplete: (success:Bool, errorMessage: String?) -> Void) {
        
        /* Build the url */
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        
        /* Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyString = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { //handle error
                self.errors.append(error)
                didComplete(success: false, errorMessage: "A network error has occured.")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response */
            let success = Users.parseUserData(newData)
            let errorMessage: String? = success ? nil : "The email or password was not valid."
            didComplete(success: success, errorMessage: errorMessage)
            
        }
        
        task.resume()
    }
    
    
    class func parseUserData(data: NSData) -> Bool {
        var success = true;
        if let userData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? NSDictionary,
            let account = userData["account"] as? [String: AnyObject],
            let session = userData["session"] as? [String: String]
        {
            Users.key = account["key"] as! String
            Users.sessionId = session["id"]!
            Users.getUserDetail() { success in
                if success {
                    self.loading = false
                }
            }
        } else {
            success = false
        }
        return success;
    }
    
    class func getUserDetail(didComplete: (success: Bool) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(Users.key)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { //handle error
                self.errors.append(error)
                didComplete(success: false)
                return
            
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response */
            if let userData = NSJSONSerialization.JSONObjectWithData(newData, options: .MutableContainers, error: nil) as? NSDictionary,
                let user = userData["user"] as? [String: AnyObject],
                let firstName = user["first_name"] as? String,
                let lastName = user["last_name"] as? String
            {
                self.firstName = firstName
                self.lastName = lastName
                didComplete(success: true)
            }
        }
        task.resume()
    }
    
    
    class func logOut(didComplete: (success: Bool) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.errors.append(error)
                didComplete(success: false)
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            didComplete(success: true)
        }
        task.resume()
    }
    
    
    
}


