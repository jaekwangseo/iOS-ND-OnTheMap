//
//  ParseClient.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/13/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    static let sharedInstance = ParseClient()
    
    var studentLocation: StudentLocation?
    
    // MARK: GET
    func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: buildURL(parameters, withPathExtension: method))
        request.addValue(Constants.ParseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()

        print("request.URL: \(request.URL)")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), errorString: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code of \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: POST
    func taskForPOSTMethod(method: String, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        
        let request = NSMutableURLRequest(URL: buildURL([String : AnyObject](), withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.ParseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo), errorString: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code of \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    func taskForPUTMethod(method: String, jsonBody: String, completionHandlerForPUT: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        
        let request = NSMutableURLRequest(URL: buildURL([String : AnyObject](), withPathExtension: method))
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.ParseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo), errorString: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code of \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    private func buildURL(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
        
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let error = "Could not parse the data as JSON: '\(data)'"
            let userInfo = [NSLocalizedDescriptionKey : error ]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo), errorString: error)
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil, errorString: nil)
    }
    
}