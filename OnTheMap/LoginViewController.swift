//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 6/17/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit

class LoginViewController: ErrorAlertViewController, UINavigationControllerDelegate {
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var myGradientView: GradientView!
        
    
    @IBAction func loginBtn(sender: AnyObject) {
        if usernameTextField!.text.isEmpty {
            debugTextLabel.text = "Username is required"
        } else if passwordTextField.text.isEmpty {
            debugTextLabel.text = "Password is required"
        } else {
            loginToUdacity()
            loginBtn.titleLabel?.text = "Loggin in, plz wait..."
            
        }
    }
    
    func loginToUdacity() {
        
        if let username = usernameTextField.text, password = passwordTextField.text {
            
            //Check to see if the credentials are valid and switch back to main thread
            Users.login(username, password: password) { (success, errorMessage) in
                if success {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.performSegueWithIdentifier("showTabbedView", sender: self)
                    }
                } else {
                    if let message = errorMessage {
                         NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.showErrorAlert("Could not log you in.", defaultMessage: message, errors: Users.errors)
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        //set color of buttons and labels
        loginBtn.backgroundColor = UIColor.customColor(redValue: 106, greenValue: 106, blueValue: 106, alpha: 1)
        titleLabel.textColor = UIColor.customColor(redValue: 153, greenValue: 153, blueValue: 106, alpha: 1)
        passwordLabel.textColor = UIColor.customColor(redValue: 102, greenValue: 102, blueValue: 102, alpha: 1)
        userLabel.textColor = UIColor.customColor(redValue: 102, greenValue: 102, blueValue: 102, alpha: 1)
        debugTextLabel.textColor = UIColor.customColor(redValue: 102, greenValue: 102, blueValue: 102, alpha: 1)
        
    }
    
    //set the background color
    override func viewDidLayoutSubviews() {
        self.myGradientView.gradientWithColors()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        /* hide the error message until there is an error */
        debugTextLabel.text = nil
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    // keyboard notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        if passwordTextField.editing {
            return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
    }
    
   
}



