//
//  SVRequestHandler.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

public class SVRequestHandler: NSObject, SVRequestDelegate
{
    // MARK: - Request
    public let request: SVRequest
    
    // MARK: - Initialization
    public init(request: SVRequest)
    {
        self.request = request
        super.init()
        self.request.delegate = self
    }
    
    // MARK: - Deinitialization
    deinit
    {
        request.delegate = nil
    }
    
    // MARK: - Subclass Implementation
    public func handleCompletionWithData(data: NSData, response: NSURLResponse)
    {
        fatalError("Subclasses of SVRequestHandler must override handleCompletionWithData:response:")
    }
    
    public func handleFailureWithError(error: NSError?, response: NSURLResponse)
    {
        fatalError("Subclasses of SVRequestHandler must override handleFailureWithError:response:")
    }
    
    // MARK: - Request Delegate
    public func request(request: SVRequest, finishedWithData data: NSData, response: NSURLResponse)
    {
        handleCompletionWithData(data, response: response)
    }
    
    public func request(request: SVRequest, failedWithError error: NSError?, response: NSURLResponse)
    {
        handleFailureWithError(error, response: response)
    }
}
