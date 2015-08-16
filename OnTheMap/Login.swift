//
//  Login.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 8/7/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation
import UIKit

class Login {
    func attemptToLogIn(usernameTextField: String, passwordTextField: String, completionHandler: (success: Bool, error: String?) -> Void) {
        var body = buildLoginBody(usernameTextField, passwordTextField: passwordTextField)
        var headers = [String: String]()
        var queryString = [String:String]()
        var loginRequest = APIHelper.postRequest(APIHelper.BaseURLs.Login, api: APIHelper.APIs.Session, body: body, headers: headers, queryString: queryString)
        var task = APIHelper.buildTask(loginRequest){(data, error) in
            if let e = error{
                completionHandler(success: false, error: "There was an issue contacting the server")
            } else {
                let subSetData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                let response = NSJSONSerialization.JSONObjectWithData(subSetData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                println(response)
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                } else {
                    self.buildUser(response!)
                    completionHandler(success: true, error: nil)
                }
            }
        }
    }
    
    func getUserInfo(userID: String, completionHandler: (success: Bool, error: String?) -> Void) {
        var headers: [String: String] = [:]
        var queryString: [String: String] = [:]
        let api = APIHelper.APIs.UserData.stringByReplacingOccurrencesOfString("{id}", withString: userID, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        var userInfoRequest = APIHelper.getRequest(APIHelper.BaseURLs.Login, api: api, headers: headers, queryString: queryString)
        var task = APIHelper.buildTask(userInfoRequest) { (data, error) in
            if let e = error{
                completionHandler(success: false, error: "There was an issue contacting the server")
            } else {
                let subSetData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                let response = NSJSONSerialization.JSONObjectWithData(subSetData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                println(response)
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                } else {
                    self.extendUser(response!)
                    completionHandler(success: true, error: nil)
                }
                
            }
        }
    }
    
    func buildLoginBody(usernameTextField: String, passwordTextField: String) -> [String: AnyObject] {
        return [
            "udacity": [
                "username": usernameTextField,
                "password": passwordTextField
            ]
        ]
    }
    
    func buildUser(jsonResponse: [String: AnyObject]) {
        let user: Users = Users(dictionary: jsonResponse)
        saveUser(user)
    }
    
    func extendUser(jsonResponse: [String: AnyObject]) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            var user = appDelegate.user
            let userResponse = jsonResponse["user"] as! [String: AnyObject]
            user?.firstName = userResponse["first_name"] as! String
            user?.lastName = userResponse["last_name"] as! String
            saveUser(user!)
        }
    }
    
    func saveUser(user: Users){
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.user = user
        }
    }
    
    
    
    func logOut(didComplete: (success: Bool) -> Void) {
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
            if error != nil { // Handle error…
                didComplete(success: false)
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            didComplete(success: true)
        }
        task.resume()
    }
}


