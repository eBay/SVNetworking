//
//  SVRemoteJSONArray.swift
//  SVNetworking
//
//  Created by Nate Stedman on 12/2/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

public enum SVRemoteJSONArrayLoadingType
{
    case Refresh
    case NextPage
}

public class SVRemoteJSONArray<T>: SVRemoteArray<T>
{
    // MARK: - Parsing
    public func checkJSON(JSON: SVJSON, error: NSErrorPointer) -> Bool
    {
        return true
    }
    
    // MARK: - Parsing - Abstract
    public func itemsForJSON(JSON: SVJSON, loadingType: SVRemoteJSONArrayLoadingType) -> [T]
    {
        fatalError("Subclasses must override itemsForJSON()")
    }
    
    public func hasNextPageForJSON(JSON: SVJSON, parsedItems: [T]) -> Bool
    {
        fatalError("Subclasses must override hasNextPageForJSON()")
    }
    
    // MARK: - Requests - Abstract
    public func buildRefreshRequest() -> SVRequest
    {
        fatalError("Subclasses must override buildRefreshRequest()")
    }
    
    public func buildNextPageRequest() -> SVRequest
    {
        fatalError("Subclasses must override buildNextPageRequest()")
    }
    
    // MARK: - Implementation - Overrides
    private var refreshHandler: SVRequestJSONHandler?
    private var nextPageHandler: SVRequestJSONHandler?
    
    public override func beginRefreshing()
    {
        refreshHandler = buildRefreshRequest().JSON({ [weak self] (JSON, response) in
            if let strongSelf = self
            {
                strongSelf.refreshHandler = nil
                var error: NSError?
                
                if strongSelf.checkJSON(JSON, error: &error)
                {
                    let items = strongSelf.itemsForJSON(JSON, loadingType: .Refresh)
                    strongSelf.finishRefreshing(items)
                }
                else
                {
                    strongSelf.failRefreshing(error)
                }
            }
        }, failure: { [weak self] (error, response) in
            if let strongSelf = self
            {
                strongSelf.refreshHandler = nil
                strongSelf.failRefreshing(error)
            }
        })
    }
    
    public override func beginLoadingNextPage()
    {
        nextPageHandler = buildNextPageRequest().JSON({ [weak self] (JSON, response) in
            if let strongSelf = self
            {
                strongSelf.nextPageHandler = nil
                var error: NSError?
                
                if strongSelf.checkJSON(JSON, error: &error)
                {
                    let items = strongSelf.itemsForJSON(JSON, loadingType: .NextPage)
                    let hasNextPage = strongSelf.hasNextPageForJSON(JSON, parsedItems: items)
                    strongSelf.finishLoadingNextPage(items, hasNextPage: hasNextPage)
                }
                else
                {
                    strongSelf.failLoadingNextPage(error)
                }
            }
            }, failure: { [weak self] (error, response) in
                if let strongSelf = self
                {
                    strongSelf.nextPageHandler = nil
                    strongSelf.failLoadingNextPage(error)
                }
        })
    }
}
