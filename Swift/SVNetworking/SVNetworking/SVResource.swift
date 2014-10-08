//
//  SVResource.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

import Foundation

@objc public protocol SVResourceObserver: class
{
    func resourceChangedState(resource: SVResource)
}

public class SVResource: NSObject
{
    // MARK: - State
    public enum State: Int
    {
        case NotLoaded
        case Loading
        case Finished
        case Failure
    }
    
    public private(set) var state: State = State.NotLoaded
    {
        didSet
        {
            enumerateObservers { (observer) -> Void in
                observer.resourceChangedState(self)
            }
        }
    }
    
    // MARK: - Observers
    private let observers = NSHashTable.weakObjectsHashTable()
    
    public func addObserver(observer: SVResourceObserver)
    {
        observers.addObject(observer)
    }
    
    public func removeObserver(observer: SVResourceObserver)
    {
        observers.removeObject(observer)
    }
    
    private func enumerateObservers(function: (observer: SVResourceObserver) -> Void)
    {
        (observers.allObjects as [SVResourceObserver]).map(function)
    }
    
    // MARK: - Loading
    public func load() -> Self
    {
        if state == .NotLoaded || state == .Failure
        {
            // remove any current error
            error = nil
            
            // adjust state
            state = .Loading
            
            // begin loading implementation
            beginLoading()
        }
        
        return self
    }
    
    public func reload() -> Self
    {
        if state != .Loading
        {
            // remove any current error
            error = nil
            
            // adjust state
            state = .Loading
            
            // begin loading implementation
            beginLoading()
        }
        
        return self
    }
    
    // MARK: - Error
    public private(set) var error: NSError?
    
    // MARK: - Implementation
    public func finishLoading()
    {
        state = .Finished
    }
    
    public func failLoadingWithError(error: NSError?)
    {
        self.error = error
        self.state = .Failure
    }
    
    // MARK: - Subclass Implementation
    public func beginLoading()
    {
        fatalError("Subclasses must override beginLoading()")
    }
}
