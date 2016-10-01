//
//  UIViewControllerExtension.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/29/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default ) { (action) in
            
        }
        
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}