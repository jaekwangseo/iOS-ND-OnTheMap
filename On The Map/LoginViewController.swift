//
//  ViewController.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/8/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUp(sender: UIButton) {
        
        let siguUpURL = NSURL(string: UdacityClient.Constants.UdacitySignUpLink)
        let request = NSURLRequest(URL: siguUpURL!)
        let webViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        webViewController.urlRequest = request
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webViewController, animated: false)
        
        self.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        
    }
    
    @IBAction func login(sender: UIButton) {
        
        guard let emailText = emailTextField.text where !emailText.isEmpty else {
            
            displayAlert("Login Failed", message: "Email is empty!")
            return
        }
        
        guard let passwordText = passwordTextField.text where !passwordText.isEmpty else {
            
            displayAlert("Login Failed", message: "Password is emtpy!")
            return
        }
        
        //
        UdacityClient.sharedInstance().authenticateWithViewController(self, email: emailText, password: passwordText) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue()) {
                if success {
                    self.completeLogin()
                } else {
                    self.displayAlert("Login Failed", message: errorString)
                }
            }

        }
        
    }
    
    func displayAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default ) { (action) in
            
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }


}

