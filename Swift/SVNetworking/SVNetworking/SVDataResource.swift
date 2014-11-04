//
//  SVDataResource.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

public class SVDataResource: SVDataRequestResource
{
    public private(set) var data: NSData?
    
    public let URL: NSURL
    
    private init(URL: NSURL)
    {
        self.URL = URL
    }
    
    public class func dataForURL(URL: NSURL) -> SVDataResource
    {
        return retrieve(URL.absoluteString!, createFunction: { return SVDataResource(URL: URL) })
    }
    
    public override func parseFinishedData(data: NSData, error: NSErrorPointer) -> Bool
    {
        self.data = data
        return true
    }
}
