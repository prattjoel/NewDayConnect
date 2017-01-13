//
//  YouTubeClient.swift
//  NewDayConnect
//
//  Created by Joel on 1/6/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation

class YouTubeClient {
    
    let sharedSession = URLSession.shared
    
    // MARK: - Setup Task for GET requests
    func taskForGetMethod (method: String, parameters: [String: AnyObject], completionHandlerForGet: @escaping (Any?, NSError?) -> Void) {
        let url = youTubeURLFromParameters(parameters: parameters, pathExtension: method)
        let request = requestSetup(url: url, httpMethod: "GET")
        let task = taskSetup(request: request, domain: "taskForGetMethod", completionHandlerForTask: completionHandlerForGet)
        
        task.resume()
    }
    
    private func youTubeURLFromParameters(parameters: [String: AnyObject]?, pathExtension: String) -> URL {
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + pathExtension
        
        
        if let params = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    private func requestSetup (url: URL, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        return request
    }
    
    private func taskSetup (request: URLRequest, domain: String, completionHandlerForTask: @escaping (Any?, NSError?) -> Void) -> URLSessionDataTask {
        
        let session = sharedSession
        let task = session.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            self.checkErrors(domain: domain, data: data, error: error, response: response, completionHandler: completionHandlerForTask)
        }
        
        return task
    }
    
    //MARK: GET request helper methods
    
    //Check for errors
    private func checkErrors(domain: String, data: Data?, error: Error?, response: URLResponse?, completionHandler: @escaping (Any?, NSError?) -> Void) {
        func sendError(error: String) {
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
        }
        
        guard (error == nil) else {
            sendError(error: "There was an error with the request: \(error)")
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError(error: "The request returned a status code other than 200: \((response as? HTTPURLResponse)?.statusCode)")
            return
        }
        
        guard let data = data else {
            sendError(error: "No data was returned by the request!")
            return
        }
        
        self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandler)
    }
    
    // Parse the data
    private func convertDataWithCompletionHandler(data: Data, completionHandlerForConvertData: (Any?, NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // Create shared instance
    class func sharedInstance() -> YouTubeClient {
        struct Singleton {
            static var sharedInstance = YouTubeClient()
        }
        
        return Singleton.sharedInstance
    }
}
