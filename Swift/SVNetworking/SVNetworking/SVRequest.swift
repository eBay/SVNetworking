/*
Copyright (c) 2014 eBay Software Foundation

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

Neither the name of eBay or any of its subsidiaries or affiliates nor the names
of its contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
    public required init(request: NSURLRequest, session: NSURLSession)
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
