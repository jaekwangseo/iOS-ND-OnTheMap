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
        
        self.uniqueKey = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as? String
        self.firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as? String
        self.lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as? String
        
    }
    
    init() {
        uniqueKey = nil
        firstName = nil
        lastName = nil
    }
}