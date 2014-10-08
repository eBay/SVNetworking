//
//  SVRequest.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

@objc public protocol SVRequestDelegate: class
{
    func request(request: SVRequest, finishedWithData data: NSData, response: NSURLResponse)
    func request(request: SVRequest, failedWithError error: NSError?, response: NSURLResponse)
}

public class SVRequest: NSObject
{
    /**
     *  The URL request this object will be a client for.
     */
    public let request: NSURLRequest
    
    /// The URL session to send the request in.
    public let session: NSURLSession
    
    /**
    Initializes a request.
    
    :param: request The URL request to send.
    */
    public convenience init(request: NSURLRequest)
    {
        self.init(request: request, session: NSURLSession.sharedSession())
    }
    
    /**
    Initializes a request
    
    :param: request The URL request to send.
    :param: session The session to send the request in.
    */
    public init(request: NSURLRequest, session: NSURLSession)
    {
        self.request = request
        self.session = session
    }
    
    deinit
    {
        task?.cancel()
    }
    
    /**
     *  The delegate for this request.
     */
    public weak var delegate: SVRequestDelegate?
    
    /// Task property
    private var task: NSURLSessionDataTask?
    
    /**
    Starts the request, unless it is already running.
    */
    public func start()
    {
        if task == nil
        {
            let task = session.dataTaskWithRequest(request, completionHandler: { [weak self] (data, response, error) in
                if let strongSelf = self
                {
                    if let strongData = data
                    {
                        strongSelf.delegate?.request(strongSelf, finishedWithData: strongData, response: response)
                    }
                    else
                    {
                        strongSelf.delegate?.request(strongSelf, failedWithError: error, response: response)
                    }
                    
                    strongSelf.task = nil
                }
            })
            
            self.task = task
            task.resume()
        }
    }
    
    /**
    Cancels the request, if it is currently in flight.
    */
    public func cancel()
    {
        task?.cancel()
        task = nil
    }
    
    /// Returns `true` if the request is running, otherwise `false`.
    public var running: Bool
    {
        return task != nil
    }
}
