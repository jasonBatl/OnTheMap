//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/8/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit

class TableViewController: LocationViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var students =  [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didRefreshLocationData", name: refreshNotification, object: nil)
        
    }
    
    func didRefreshLocationData(){
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! UITableViewCell
        
        let studentInfo = self.studentInformations[indexPath.row]
        cell.textLabel?.text = studentInfo.firstName + " " + studentInfo.lastName
        cell.detailTextLabel?.text = studentInfo.mediaURL
        cell.imageView!.image = UIImage(named: "locationIcon")
        
        return cell
    }

   // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return studentInformations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            let url = self.students[indexPath.row].mediaURL
            
            func openURL(URL:String) {
                if let link = NSURL(string: url){
                    UIApplication.sharedApplication().openURL(link)
                    return
                }
            }
           
        
    }

}
