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

public class SVRequestParameterBuilder: SVRequestBuilder
{
    /// The parameters for the request. This dictionary can be accessed directly through subscripting, via an extension.
    public var parameters: [String:String] = [:]
    
    public override func createURL() -> NSURL
    {
        let URL = super.createURL()
        
        switch (self.method)
        {
            case .GET:
                let queryString = "?\(SVRequestParameterBuilder.createParameterString(parameters))"
                return NSURL(string: queryString, relativeToURL: URL) ?? URL
                
            default:
                return URL
        }
    }
    
    
    public override func createBody() -> (data: NSData, contentType: String)?
    {
        switch (self.method)
        {
        case .GET:
            return super.createBody()
        default:
            if parameters.count > 0
            {
                return nil
            }
            else
            {
                let string = SVRequestParameterBuilder.createParameterString(parameters)
                
                if let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                {
                    return (data, "application/x-www-form-urlencoded")
                }
                else
                {
                    return nil
                }
            }
        }
    }
    
    /**
    Creates a URL parameter string from a parameter dictionary.
    
    :param: parameters The parameters to convert to a string.
    */
    public class func createParameterString(parameters: [String:String]) -> String
    {
        return "&".join(createParameterPairStrings(parameters))
    }
    
    /**
    Creates an array of URL parameter strings from a parameter dictionary.
    
    :param: parameters The parameters to convert to pair strings.
    */
    public class func createParameterPairStrings(parameters: [String:String]) -> [String]
    {
        var pairs: [String] = []
        
        for (key, value) in parameters
        {
            pairs.append("\(key)=\(URLEncode(value))")
        }
        
        return pairs
    }
    
    /**
    URL-encodes a string.
    
    :param: string The string to URL-encode.
    */
    public class func URLEncode(string: String) -> String
    {
        return string.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()) ?? string
    }
}

extension SVRequestParameterBuilder
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

extension SVRequest
{
    /**
    Returns a `GET` request for the specified URL.
    
    :param: URL        The URL to request.
    :param: parameters The parameters to include in the request.
    */
    public class func GET(URL: NSURL, parameters: [String:String]) -> Self
    {
        let builder = SVRequestParameterBuilder(URL: URL, method: .GET)
        builder.parameters = parameters
        
        return self(request: builder.request, session: NSURLSession.sharedSession())
    }
    
    /**
    Returns a `POST` request for the specified URL.
    
    :param: URL        The URL to request.
    :param: parameters The parameters to include in the request.
    */
    public class func POST(URL: NSURL, parameters: [String:String]) -> Self
    {
        let builder = SVRequestParameterBuilder(URL: URL, method: .POST)
        builder.parameters = parameters
        
        return self(request: builder.request, session: NSURLSession.sharedSession())
    }
    
    /**
    Returns a `PUT` request for the specified URL.
    
    :param: URL        The URL to request.
    :param: parameters The parameters to include in the request.
    */
    public class func PUT(URL: NSURL, parameters: [String:String]) -> Self
    {
        let builder = SVRequestParameterBuilder(URL: URL, method: .PUT)
        builder.parameters = parameters
        
        return self(request: builder.request, session: NSURLSession.sharedSession())
    }
    
    /**
    Returns a `DELETE` request for the specified URL.
    
    :param: URL        The URL to request.
    :param: parameters The parameters to include in the request.
    */
    public class func DELETE(URL: NSURL, parameters: [String:String]) -> Self
    {
        let builder = SVRequestParameterBuilder(URL: URL, method: .DELETE)
        builder.parameters = parameters
        
        return self(request: builder.request, session: NSURLSession.sharedSession())
    }
}
