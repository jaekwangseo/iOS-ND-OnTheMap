//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/13/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation


extension ParseClient {
    
    func getStudentLocations(queryLimit: Int, completionHandlerForStudentLocations: (result: [StudentLocation]?, error: NSError?) -> Void) {
        
        let parameters = [
            ParameterKeys.QueryLimit: queryLimit
        ]
        
        taskForGETMethod("", parameters: parameters) { (result, error) in
            
            if let error = error {
                print("error: \(error)")
                completionHandlerForStudentLocations(result: nil, error: error)
            } else {
                print(result)
                if let results = result[JSONResponseKeys.StudentLocationResults] as? [[String:AnyObject]] {
                    
                    let studentLocations = StudentLocation.studentLocationsFromResults(results)
                    
                    completionHandlerForStudentLocations(result: studentLocations, error: nil)
                } else {
                    completionHandlerForStudentLocations(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }

            }
        }
    }
}