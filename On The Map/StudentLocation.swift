//
//  StudentLocation.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/14/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    
    
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double) {
        
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.objectId = nil
        
        
    }
    
    
    init(dictionary: [String:AnyObject]) {
        
        
        self.objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String
        self.uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        self.firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        self.lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        self.mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        self.mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        self.latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        self.longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        
    }
    
    static func studentLocationsFromResults(results: [[String:AnyObject]]) -> [StudentLocation]? {
        
        var studentLocations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        if studentLocations.isEmpty {
            return nil
        } else {
            return studentLocations
        }
    }

    
}

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.objectId == rhs.objectId
}