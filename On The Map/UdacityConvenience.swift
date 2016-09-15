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
     
        taskForPOSTMethod(Methods.GetSession, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                print("error: \(error)")
                completionHandlerForSession(success: false, errorString: "GetUdacitySession Failed")
            } else {
                print(result)
                completionHandlerForSession(success: true, errorString: nil)
            }
        }
    }
}