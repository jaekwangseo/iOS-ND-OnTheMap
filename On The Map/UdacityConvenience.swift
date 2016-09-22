//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/9/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    
    
    func authenticateWithViewController(hostViewController: UIViewController, email: String, password: String, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        getSessionIdWith(email, password: password) { (success, errorString) in
            
            completionHandlerForAuth(success: success, errorString: errorString)
        
        }
    }
    

    func getSessionIdWith(email: String, password: String, completionHandlerForSession: (success: Bool, errorString: String?) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
     
        taskForPOSTMethod(Methods.GetSession, jsonBody: jsonBody) { (result, error, errorString) in
            
            if let error = error {
                print("error: \(error)")
                completionHandlerForSession(success: false, errorString: errorString)
            } else {
                print("getSessionIdWith Result: \(result)")
                if let result = result as? [String: AnyObject] {
                    if let account = result[JSONResponseKeys.Account] as? [String: AnyObject]{
                        UdacityClient.sharedInstance().currentUser = UdacityUser()
                        UdacityClient.sharedInstance().currentUser?.uniqueKey = account[JSONResponseKeys.UniqueKey] as? String
                    }
                }
                completionHandlerForSession(success: true, errorString: nil)
            }
        }
    }
    
    func getUserData(userKey: String, completionHandlerForUserData: (success: Bool, user: UdacityUser?, errorString: String?) -> Void) {
        
        taskForGETMethod(Utility.sharedInstance().subtituteKeyInMethod(Methods.User, key: URLKeys.UserId , value: userKey)! ) { (result, error, errorString) in
            
            if let error = error {
                print("error: \(error)")
                completionHandlerForUserData(success: false, user: nil, errorString: "getUserData Failed")
            } else {
                print("getUserData Result: \(result)")
                if let result = result as? [String: AnyObject], let user = result[JSONResponseKeys.User] as? [String: AnyObject] {
                    
                    completionHandlerForUserData(success: true, user: UdacityUser(dictionary: user), errorString: nil)
                } else {
                    completionHandlerForUserData(success: false, user: nil, errorString: "getUerData Failed")
                }
            }

            
        }
        
    }
}