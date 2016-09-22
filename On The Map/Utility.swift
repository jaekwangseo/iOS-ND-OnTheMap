//
//  Utility.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/20/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation


class Utility {

    // substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> Utility {
        struct Singleton {
            static var sharedInstance = Utility()
        }
        return Singleton.sharedInstance
    }
    

    
}

