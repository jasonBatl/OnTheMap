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
    
    //stores the pins
    var studentInformations = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButtonItems([refreshButton, locationIcon], animated: false)
        loadLocationData()
    }
    
    @IBAction func refreshPressed(sender: UIBarButtonItem) {
        self.loadLocationData()
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        sender.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func pinPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showPost", sender: self)
    }
    
    func loadLocationData() {
        
        //Download student info
        var infoApi = StudentLocation()
        infoApi.getRecentStudents() { (info, success, error) in
            if success {
                self.studentInformations = info!
                self.useInfo()
            } else {
                let alert = UIAlertView()
                alert.title = "issue retriving data"
                alert.message = "could not load data. Try again."
                alert.addButtonWithTitle("Ok")
                dispatch_async(dispatch_get_main_queue(),{
                  alert.show()
                })
            }
        }
    }
    
    func useInfo(){}
}
