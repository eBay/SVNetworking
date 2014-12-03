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

public enum SVRemoteArrayLoadingState
{
    case NotLoading
    case Loading
    case Error
}

private class SVRemoteArrayObserverLink<T>
{
    weak var observer: SVRemoteArrayObserver<T>?
}

public class SVRemoteArray<T>
{
    // MARK: - Data
    public private(set) var contents: [T] = []
    
    public subscript(index: Int) -> T {
        return contents[index]
    }
    
    /// The number of items in the remote array.
    public var count: Int {
        return contents.count
    }
    
    // MARK: - Loading Instructions
    public func loadNextPage()
    {
        if !isLoadingNextPage && hasNextPage
        {
            // notify observers
            enumerateObservers { (observer) -> () in
                if let function = observer.willBeginLoadingNextPage
                {
                    function(remoteArray: self)
                }
            }
            
            // clear error
            nextPageError = nil
            
            // change loading state
            nextPageLoadingState = .Loading
            
            // load the next page
            beginLoadingNextPage()
            
            // notify observers
            enumerateObservers { (observer) -> () in
                if let function = observer.didBeginLoadingNextPage
                {
                    function(remoteArray: self)
                }
            }
        }
    }
    
    public func refresh()
    {
        if refreshable && !isRefreshing && (count > 0 || !hasNextPage)
        {
            // notify observers
            enumerateObservers { (observer) -> () in
                if let function = observer.willBeginRefreshing
                {
                    function(remoteArray: self)
                }
            }
            
            // clear error
            refreshError = nil
            
            // change loading state
            refreshLoadingState = .Loading
            
            // load the next page
            beginRefreshing()
            
            // notify observers
            enumerateObservers { (observer) -> () in
                if let function = observer.didBeginRefreshing
                {
                    function(remoteArray: self)
                }
            }
        }
    }
    
    // MARK: - Loading State
    /// If the remote array is loading the next page or not.
    public var isLoadingNextPage: Bool {
        return nextPageLoadingState == .Loading
    }
    
    /// The current state of loading the next page.
    public private(set) var nextPageLoadingState = SVRemoteArrayLoadingState.NotLoading
    
    /// If the remote array is refreshing or not.
    public var isRefreshing: Bool {
        return refreshLoadingState == .Loading
    }
    
    /// The current state of refreshing.
    public private(set) var refreshLoadingState = SVRemoteArrayLoadingState.NotLoading
    
    /// If the remote array has an additional page to load.
    public private(set) var hasNextPage = true
    
    // MARK: - Refreshability
    public var refreshable: Bool {
        return true
    }
    
    // MARK: - Loading Errors
    public private(set) var nextPageError: NSError?
    public private(set) var refreshError: NSError?
    
    // MARK: - Subclass Implementation
    public func beginRefreshing()
    {
        fatalError("Subclasses must override beginRefreshing()")
    }
    
    public func beginLoadingNextPage()
    {
        fatalError("Subclasses must override beginLoadingNextPage()")
    }
    
    // MARK: - Implementation - Refresh
    public func finishRefreshing(items: [T])
    {
        self.contents = items + self.contents
        self.refreshLoadingState = .NotLoading
        
        enumerateObservers { (observer) -> () in
            if let function = observer.didRefresh
            {
                function(remoteArray: self, items: items)
            }
        }
    }
    
    public func failRefreshing(error: NSError?)
    {
        self.refreshError = error
        self.refreshLoadingState = .Error
        
        enumerateObservers { (observer) -> () in
            if let function = observer.failedToRefresh
            {
                function(remoteArray: self, error: error)
            }
        }
    }
    
    // MARK: - Implementation - Next Page
    public func finishLoadingNextPage(items: [T], hasNextPage: Bool)
    {
        self.contents.extend(items)
        self.hasNextPage = hasNextPage
        self.nextPageLoadingState = .NotLoading
        
        enumerateObservers { (observer) -> () in
            if let function = observer.didLoadNextPage
            {
                function(remoteArray: self, items: items)
            }
        }
    }
    
    public func failLoadingNextPage(error: NSError?)
    {
        self.nextPageError = error
        self.nextPageLoadingState = .Error
        
        enumerateObservers { (observer) -> () in
            if let function = observer.failedToLoadNextPage
            {
                function(remoteArray: self, error: error)
            }
        }
    }
    
    // MARK: - Pagination Observers
    private var observerLinks: [SVRemoteArrayObserverLink<T>] = []
    
    private func enumerateObservers(function: (observer: SVRemoteArrayObserver<T>) -> ())
    {
        for link in observerLinks
        {
            link.observer.map { (observer) in function(observer: observer) }
        }
    }
    
    func addObserver(observer: SVRemoteArrayObserver<T>)
    {
        let link = SVRemoteArrayObserverLink<T>()
        link.observer = observer
        
        observerLinks.append(link)
    }
    
    func removeObserver(observer: SVRemoteArrayObserver<T>)
    {
        observerLinks = observerLinks.filter { (link) in
            link.observer.map { (linked) in linked === observer } ?? false
        }
    }
}
