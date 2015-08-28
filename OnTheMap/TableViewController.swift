//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/8/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//
import Foundation
import UIKit

class TableViewController: TabViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformations.count
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! UITableViewCell
        
        let pin = self.studentInformations[indexPath.row]
        cell.textLabel?.text = pin.firstName + " " + pin.lastName
        cell.detailTextLabel?.text = pin.mediaURL
        cell.imageView!.image = UIImage(named: "locationIcon")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = self.studentInformations[indexPath.row].mediaURL
        goToURL(url)
    }
    
    override func useInfo() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

}
