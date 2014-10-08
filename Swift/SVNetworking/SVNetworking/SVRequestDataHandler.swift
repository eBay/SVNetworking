//
//  SVRequestDataHandler.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

public class SVRequestDataHandler: SVRequestHandler
{
    /// Type alias for completion handler
    public typealias Completion = (data: NSData, response: NSURLResponse) -> Void
    
    /// Type alias for failure handler
    public typealias Failure = (error: NSError?, response: NSURLResponse) -> Void
    
    /// A function to run upon successful completion of the request
    public var completion: Completion?
    
    // A function to run when the request fails.
    public var failure: Failure?
    
    public override func handleCompletionWithData(data: NSData, response: NSURLResponse)
    {
        if let completion = self.completion
        {
            completion(data: data, response: response)
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
