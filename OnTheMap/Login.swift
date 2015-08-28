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
    func attemptToLogIn(email: String, password: String, completionHandler: (success: Bool, error: String?) -> Void) {
        var body = buildLoginBody(email, password: password)
        var headers = [String: String]()
        var queryString = [String:String]()
        var loginRequest = APIHelper.postRequest(APIHelper.BaseURLs.Login, api: APIHelper.APIs.Session, body: body, headers: headers, queryString: queryString)
        var task = APIHelper.buildTask(loginRequest){(data, error) in
            if let e = error{
                completionHandler(success: false, error: "There was an issue contacting the server")
            } else {
                let subSetData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                let response = NSJSONSerialization.JSONObjectWithData(subSetData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
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
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                } else {
                    self.extendUser(response!)
                    completionHandler(success: true, error: nil)
                }
                
            }
        }
    }
    
    func buildLoginBody(email: String, password: String) -> [String: AnyObject] {
        return [
            "udacity": [
                "username": email,
                "password": password
            ]
        ]
    }
    
    func buildUser(jsonResponse: [String: AnyObject]) {
        let user: User = User(dictionary: jsonResponse)
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
    
    func saveUser(user: User){
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.user = user
        }
    }


}


