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
        
        taskForGETMethod("", parameters: parameters) { (result, error, errorString) in
            
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
    
    func getStudentLocation(uniqueKey: String, completionHandlerForStudentLocation: (result: StudentLocation?, error: NSError?) -> Void) {
        
        let parameters = [
            ParameterKeys.Where : "{\"uniqueKey\":\"\(uniqueKey)\"}"
        ]
        
        taskForGETMethod("", parameters: parameters) { (result, error, errorString) in
            if let error = error {
                print("error: \(error)")
                completionHandlerForStudentLocation(result: nil, error: error)
            } else {
                print(result)
                if let results = result[JSONResponseKeys.StudentLocationResults] as? [[String:AnyObject]] {
                    
                    let studentLocations = StudentLocation.studentLocationsFromResults(results)
                    if let studentLocation = studentLocations?[0] {
                        //Success
                        completionHandlerForStudentLocation(result: studentLocation, error: nil)
                    } else {
                        completionHandlerForStudentLocation(result: nil, error: NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                    }
                    
                } else {
                    //Fail
                    completionHandlerForStudentLocation(result: nil, error: NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                }
            }
        }
    }
    
    func newStudentLocation(studentLocation: StudentLocation, completionHandlerForStudentLocation: (objectId: String?, error: NSError?) -> Void) {
        
        let jsonBody = "{\"uniqueKey\": \"\(studentLocation.uniqueKey!)\", \"firstName\": \"\(studentLocation.firstName!)\", \"lastName\": \"\(studentLocation.lastName!)\",\"mapString\": \"\(studentLocation.mapString!)\", \"mediaURL\": \"\(studentLocation.mediaURL!)\",\"latitude\": \(studentLocation.latitude!), \"longitude\": \(studentLocation.longitude!)}"
        
        taskForPOSTMethod("", jsonBody: jsonBody) { (result, error, errorString) in
            if let error = error {
                print("error: \(error)")
                completionHandlerForStudentLocation(objectId: nil, error: NSError(domain: "newStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse newStudentLocation"]))
            } else {
                print("newSessionIdWith Result: \(result)")
                if let result = result as? [String: AnyObject], let objectId = result[JSONResponseKeys.ObjectId] as? String {
                    
                    completionHandlerForStudentLocation(objectId: objectId, error: nil)
                    
                } else {
                    completionHandlerForStudentLocation(objectId: nil, error: NSError(domain: "newStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse newStudentLocation"]))
                }
                
            }

        }
    }
}