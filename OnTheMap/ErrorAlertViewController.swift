//
//  ErrorAlertViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 6/24/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit
import MapKit

class ErrorAlertViewController: UIViewController {
    
    internal func showErrorAlert(title: String, defaultMessage: String, errors: [NSError]) {
        var message = defaultMessage
        if !errors.isEmpty {
            message = errors[0].localizedDescription
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
