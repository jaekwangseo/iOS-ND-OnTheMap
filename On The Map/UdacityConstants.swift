//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/9/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation


// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        static let UdacitySignUpLink = "https://www.udacity.com/account/auth#!/signup"

    }
    
    struct Methods {
        
        static let GetSession = "/session"
        static let User = "/users/{user_id}"
        
    }
    
    struct URLKeys {
        static let UserId = "user_id"
    }
    
    struct JSONResponseKeys {

        static let Account = "account"
        static let User = "user"
        
        // MARK: Udacity User
        static let UniqueKey = "key"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
        
    }
}