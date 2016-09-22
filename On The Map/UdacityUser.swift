//
//  UdacityUser.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/20/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation


struct UdacityUser {
    
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?

    
    init(dictionary: [String:AnyObject]) {
        
        if let uniqueKey = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            self.uniqueKey = nil
        }
        if let firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as? String {
            self.firstName = firstName
        } else {
            self.firstName = nil
        }
        if let lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as? String {
            self.lastName = lastName
        } else {
            self.lastName = nil
        }
    }
    
    init() {
        uniqueKey = nil
        firstName = nil
        lastName = nil
    }
}