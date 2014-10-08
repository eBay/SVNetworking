//
//  SVRequestJSONHandler.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

public class SVRequestJSONHandler: SVRequestHandler
{
    /// Type alias for completion handler
    public typealias Completion = (JSON: [NSObject: AnyObject], response: NSURLResponse) -> Void
    
    /// Type alias for failure handler
    public typealias Failure = (error: NSError?, response: NSURLResponse) -> Void
    
    /// A function to run upon successful completion of the request
    public var completion: Completion?
    
    // A function to run when the request fails.
    public var failure: Failure?
    
    /**
    Allows subclasses to provide custom JSON errors.
    
    Override this method and check the JSON values, then call `handleFailureWithError:response:` if the JSON data is
    invalid. Otherwise, call the `super` implementation.
    
    :param: JSON     The parsed JSON object.
    :param: response The URL response from the request.
    */
    public func handleCompletionWithJSON(JSON: [NSObject: AnyObject], response: NSURLResponse)
    {
        if let completion = self.completion
        {
            completion(JSON: JSON, response: response)
        }
    }
    
    public override func handleCompletionWithData(data: NSData, response: NSURLResponse)
    {
        var error: NSError?
        
        if let JSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [NSObject: AnyObject]
        {
            handleCompletionWithJSON(JSON, response: response)
        }
        else
        {
            handleFailureWithError(error, response: response)
        }
    }
    
    public override func handleFailureWithError(error: NSError?, response: NSURLResponse)
    {
        if let failure = self.failure
        {
            failure(error: error, response: response)
        }
    }
}
