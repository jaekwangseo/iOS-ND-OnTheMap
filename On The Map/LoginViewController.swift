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
    
    @IBAction func login(sender: UIButton) {
        
        guard let emailText = emailTextField.text where !emailText.isEmpty else {
            return
        }
        
        guard let passwordText = passwordTextField.text where !passwordText.isEmpty else {
            return
        }
        
        //
        UdacityClient.sharedInstance().authenticateWithViewController(self, email: emailText, password: passwordText) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue()) {
                if success {
                    self.completeLogin()
                } else {
                    //self.displayError(errorString)
                }
            }

        }
        
    }

    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }

    private func displayError(errorString: String?) {
        if let errorString = errorString {
            //debugTextLabel.text = errorString
        }
    }


}

