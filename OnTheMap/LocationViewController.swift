//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/7/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit

class LocationViewController: ErrorAlertViewController {
    
    @IBOutlet var locationIcon: UIBarButtonItem!
    @IBOutlet var refreshButton: UIBarButtonItem!
    
    let refreshNotification = "Location Data Refreshing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButtonItems([refreshButton, locationIcon], animated: false)
    }
    
    @IBAction func refreshPressed(sender: UIBarButtonItem) {
        self.loadLocationData(forceRefresh:true) {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: self.refreshNotification, object: self))
        }
        
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        sender.enabled = false
        Users.logOut() { success in
            sender.enabled = true
            if !success {
                self.showErrorAlert("Logout Unsuccessful", defaultMessage: "Could not log you out", errors: Users.errors)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func pinPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showPost", sender: self)
    }
    
    internal func loadLocationData(forceRefresh: Bool = false, didComplete: (() -> Void)?) {
        StudentLocation.getRecent(forceRefresh: forceRefresh) { success in
            if !success {
                self.showErrorAlert("Error Loading Locations", defaultMessage: "Loading failed.", errors: StudentLocation.errors)
            } else if !StudentLocation.locations.isEmpty && didComplete != nil{
                didComplete!()
            }
        }
    }
    
}
