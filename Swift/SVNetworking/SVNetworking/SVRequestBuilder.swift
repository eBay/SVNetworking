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
        case HEAD = "HEAD"
        case TRACE = "TRACE"
        case OPTIONS = "OPTIONS"
        case CONNECT = "CONNECT"
        case PATCH = "PATCH"
    }
    
    /// The URL assigned to the builder.
    public let URL: NSURL
    
    /// The HTTP method assigned to the builder.
    public let method: Method
    
    /**
    Initializes a request builder.
    
    :param: URL    The URL for the builder.
    :param: method The HTTP method for the builder.
    */
    public init(URL: NSURL, method: Method)
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
            return SVRequestBuilder(URL: URL, method: method)
        }
        else
        {
            return nil
        }
    }
    
    /// The parameters for the request. This dictionary can be accessed directly through subscripting, via an extension.
    public var parameters: [String:String] = [:]
    
    /// The HTTP headers for the request.
    public var headers: [String:String] = [:]
}

extension SVRequestBuilder
{
    public subscript (parameter: String) -> String?
    {
        get
        {
            return parameters[parameter]
        }
        
        set (newValue)
        {
            parameters[parameter] = newValue
        }
    }
}
