//
//  SVResourceClient.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

public class SVResourceObjCClient: NSObject, SVResourceObserver
{
    public typealias Handler = (resource: SVResource) -> Void
    
    private let handler: Handler
    private let resource: SVResource
    
    init(resource: SVResource, handler: Handler)
    {
        self.resource = resource
        self.handler = handler
        
        super.init()
        
        self.resource.addObserver(self)
    }
    
    deinit
    {
        self.resource.removeObserver(self)
    }
    
    public func resourceChangedState(resource: SVResource)
    {
        handler(resource: self.resource)
    }
    
    public func apply() -> Self
    {
        handler(resource: self.resource)
        return self
    }
}

public class SVResourceClient<T:SVResource>: NSObject
{
    public typealias Handler = (resource: T) -> Void
    
    private var innerClient: SVResourceObjCClient?
    private let handler: SVResourceClient.Handler
    private let resource: T
    
    init(resource: T, handler: Handler)
    {
        self.resource = resource
        self.handler = handler
        
        super.init()
        
        self.innerClient = SVResourceObjCClient(resource: resource, handler: { [weak self] (resource) in
            if let strongSelf = self
            {
                strongSelf.handler(resource: strongSelf.resource)
            }
        })
    }
    
    public func apply() -> Self
    {
        handler(resource: self.resource)
        return self
    }
}

extension SVResource
{
    public func addClient(handler: SVResourceClient<SVResource>.Handler) -> SVResourceClient<SVResource>
    {
        return SVResourceClient(resource: self, handler: handler)
    }
    
    public func addObjCClient(handler: SVResourceObjCClient.Handler) -> SVResourceObjCClient
    {
        return SVResourceObjCClient(resource: self, handler: handler)
    }
}
