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

public extension SVRequest
{
    public func JSON(completion: SVRequestJSONHandler.Completion, failure: SVRequestJSONHandler.Failure) -> SVRequestJSONHandler
    {
        let handler = SVRequestJSONHandler(request: self)
        
        handler.completion = completion
        handler.failure = failure
        
        start()
        
        return handler
    }
}
