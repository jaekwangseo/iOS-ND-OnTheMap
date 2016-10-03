//
//  UdacityClient.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/9/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation


class UdacityClient {
    
    static let sharedInstance = UdacityClient()
    
    var currentUser: UdacityUser? = nil
    
    // MARK: POST
    func taskForPOSTMethod(method: String, jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) -> NSURLSessionDataTask {
        

        let request = NSMutableURLRequest(URL: buildURL(method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: NSError?, errorMessage: String) {
                
                if error != nil {
                    print("error: \(error!)")
                    let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo), errorString: error!.localizedDescription)
                } else {
                    print("error: \(errorMessage)")
                    let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo), errorString: errorMessage)
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!, errorMessage: "There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                
                if let data = data {
                    
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                    
                    print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                    
                    if let parsedResult = self.convertData(newData) {
                        
                        if let errorString = parsedResult["error"] as? String {
                            sendError(nil, errorMessage: errorString)
                            return
                        }
                        
                    }
                    
                }
                
                sendError(nil, errorMessage: "Your request returned status code of \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(nil, errorMessage: "No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    func taskForGETMethod(method: String, completionHandlerForGET: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: buildURL(method))
        
        let session = NSURLSession.sharedSession()
        
        print("request.URL: \(request.URL)")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: NSError?, errorMessage: String) {
                
                if error != nil {
                    print("error: \(error!)")
                    let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), errorString: error!.localizedDescription)
                } else {
                    print("error: \(errorMessage)")
                    let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), errorString: errorMessage)
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error, errorMessage: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError(nil, errorMessage: "Your request returned status code of \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(nil, errorMessage: "No data was returned by the request!")
                return
            }
            
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    func taskForDELETEMethod(method: String, completionHandlerForDELETE: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) -> NSURLSessionDataTask
    {
        
        let request = NSMutableURLRequest(URL: buildURL(method))
        
        let session = NSURLSession.sharedSession()

        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: NSError?, errorMessage: String) {
                
                if error != nil {
                    print("error: \(error!)")
                    let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandlerForDELETE(result: nil, error: NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo), errorString: error!.localizedDescription)
                } else {
                    print("error: \(errorMessage)")
                    let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandlerForDELETE(result: nil, error: NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo), errorString: errorMessage)
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error, errorMessage: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError(nil, errorMessage: "Your request returned status code of \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(nil, errorMessage: "No data was returned by the request!")
                return
            }
            
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
            
        }
        
        task.resume()
        
        return task
    }
    
    
    private func buildURL(withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")

        
        return components.URL!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?, errorString: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let errorString = "Could not parse the data as JSON: '\(data)'"
            let userInfo = [NSLocalizedDescriptionKey : errorString ]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo), errorString: errorString)
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil, errorString: nil)
    }
    
    private func convertData(data: NSData) -> AnyObject? {
        
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            return parsedResult
        } catch {
            return nil
        }
    }
    
}