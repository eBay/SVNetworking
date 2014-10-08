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

public class SVRequestBuilder: NSObject
{
    public enum Method: String
    {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    // MARK: - Basic Properties
    
    /// The URL assigned to the builder.
    public let URL: NSURL
    
    /// The HTTP method assigned to the builder.
    public let method: Method
    
    // MARK: - Initialization
    
    /**
    Initializes a request builder.
    
    :param: URL    The URL for the builder.
    :param: method The HTTP method for the builder.
    */
    public required init(URL: NSURL, method: Method)
    {
        self.URL = URL
        self.method = method
    }
    
    /**
    Provided for compatibility with Objective-C. Use the standard `init` in Swift code.
    
    :param: URL          The URL for the builder.
    :param: methodString An HTTP method string. If invalid, this function will return `nil`.
    */
    public class func builderWithURL(URL: NSURL, methodString: String) -> SVRequestBuilder?
    {
        if let method = Method(rawValue: methodString)
        {
            return self(URL: URL, method: method)
        }
        else
        {
            return nil
        }
    }
    
    // MARK: - Headers
    
    /// The HTTP headers for the request.
    public var headers: [String:String] = [:]
    
    // MARK: - Request
    public var request: NSURLRequest
    {
        return createRequest()
    }
    
    public func createRequest() -> NSMutableURLRequest
    {
        let request = NSMutableURLRequest(URL: createURL())
        
        request.HTTPMethod = method.rawValue
        
        for (header, value) in headers
        {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        if let bodyTuple = self.createBody()
        {
            request.HTTPBody = bodyTuple.data
            request.setValue("\(bodyTuple.data.length)", forHTTPHeaderField: "Content-Length")
            request.setValue(bodyTuple.contentType, forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    public func createURL() -> NSURL
    {
        return URL
    }
    
    public func createBody() -> (data: NSData, contentType: String)?
    {
        return nil
    }
}
