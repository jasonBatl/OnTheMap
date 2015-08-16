//
//  users.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 6/23/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation

struct Users {
    
    var id = ""
    var key = ""
    var firstName = ""
    var lastName = ""
    
    init(dictionary: [String: AnyObject]){
        if let session = dictionary["session"] as? [String: AnyObject] {
            if let account = dictionary["account"] as? [String: AnyObject] {
                id = session["id"] as! String
                key = account["key"] as! String
            }
        }
    }
}


