//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 6/17/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var myGradientView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.user = User(dictionary: [:])
        }
        
        
        //set color of buttons and labels
        loginBtn.backgroundColor = UIColor.customColor(redValue: 106, greenValue: 106, blueValue: 106, alpha: 1)
        titleLabel.textColor = UIColor.customColor(redValue: 153, greenValue: 153, blueValue: 106, alpha: 1)
        passwordLabel.textColor = UIColor.customColor(redValue: 102, greenValue: 102, blueValue: 102, alpha: 1)
        userLabel.textColor = UIColor.customColor(redValue: 102, greenValue: 102, blueValue: 102, alpha: 1)
        debugTextLabel.textColor = UIColor.customColor(redValue: 102, greenValue: 102, blueValue: 102, alpha: 1)
        
    }
        
    
    @IBAction func loginBtnClicked(sender: AnyObject) {
        if email.text.isEmpty {
            self.displayError("Username is required")
        } else if password.text.isEmpty {
            self.displayError("Password is required")
        } else {
        
            loginBtn.titleLabel?.text = "Loggin in, plz wait..."
            loginBtn.enabled = false
            
            //Check to see if the credentials are valid and switch back to main thread
            Login().attemptToLogIn(email.text, password: password.text){ (success, error) in
                if success {
                    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                        var user = appDelegate.user
                        Login().getUserInfo(user!.key){ (success, error) in
                            if success {
                               self.logInSuccessful()
                            } else {
                                self.displayError("There was an issue loggin you in.")
                                self.loginBtn.enabled = true
                            }
                        }
                    } else {
                        self.displayError(error)
                        self.loginBtn.enabled = true
                    }
                } else {
                    self.displayError(error)
                    self.loginBtn.enabled = true
                }
            }
            self.loginBtn.enabled = true
            loginBtn.titleLabel?.text = "Log in"
            
        }
    }
    
    func logInSuccessful() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabbedView") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
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
        
        if textField == email {
            password.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func displayError(error: String?) {
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = error
        alert.addButtonWithTitle("OK")
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = error {
                alert.show()
            }
        })
        loginBtn.enabled = true
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
        if password.editing {
            return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
    }
    
   
}



