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
        
        if let objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String {
            self.objectId = objectId
        } else {
            self.objectId = nil
        }
        if let uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            self.uniqueKey = nil
        }
        if let firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String {
            self.firstName = firstName
        } else {
            self.firstName = nil
        }
        if let lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String {
            self.lastName = lastName
        } else {
            self.lastName = nil
        }
        if let mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String {
            self.mapString = mapString
        } else {
            self.mapString = nil
        }
        if let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        } else {
            self.mediaURL = nil
        }
        if let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double {
            self.latitude = latitude
        } else {
            self.latitude = nil
        }
        if let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double {
            self.longitude = longitude
        } else {
            self.longitude = nil
        }
        
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