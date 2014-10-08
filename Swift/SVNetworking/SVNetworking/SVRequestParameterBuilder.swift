//
//  SVRequestParameterBuilder.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

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
                let queryString = "?\(createParameterString())"
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
                let string = createParameterString()
                
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
    
    public func createParameterString() -> String
    {
        return "&".join(createParameterPairs())
    }
    
    public func createParameterPairs() -> [String]
    {
        var pairs: [String] = []
        
        for (key, value) in parameters
        {
            pairs.append("\(key)=\(SVRequestParameterBuilder.URLEncode(value))")
        }
        
        return pairs
    }
    
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
