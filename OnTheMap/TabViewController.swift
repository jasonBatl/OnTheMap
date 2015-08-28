//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 8/28/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//
import Foundation
import UIKit

class TabViewController: UIViewController {
    
    @IBOutlet var locationIcon: UIBarButtonItem!
    @IBOutlet var refreshButton: UIBarButtonItem!
    
    //Stores the pin
    var studentInformations = [StudentInformation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        navigationItem.setRightBarButtonItems([refreshButton, locationIcon], animated: false)
        // Do any additional setup after loading the view.
    }

    func getInfo() {
        var infoAPI = StudentLocation()
        //pins are getting downloaded here
        infoAPI.GETStudentInformations(){ (info, success, error) in
            if success{
                self.studentInformations = info!
                self.useInfo()
            } else {
                self.showFailureToDownloadMessage()
            }
        }
    }
    
    func goToURL(url: String) {
        if let link = NSURL(string: url){
            UIApplication.sharedApplication().openURL(link)
            return
        }
        showBadURLMessage()
    }

    func showBadURLMessage(){
        let alert = UIAlertView()
        alert.title = "Bad URL"
        alert.message = "This person entered an invalid Email"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func showFailureToDownloadMessage(){
        let alert = UIAlertView()
        alert.title = "issue getting data"
        alert.message = "Encountered an error loading data. Please try again later"
        alert.addButtonWithTitle("OK")
        dispatch_async(dispatch_get_main_queue(), {
            alert.show()
        })
    }
    
    func useInfo(){}
    
    @IBAction func pinPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showPost", sender: self)
    }
    
    @IBAction func refreshPressed(sender: UIBarButtonItem) {
       self.getInfo()
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        sender.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
