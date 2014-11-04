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

@objc public protocol SVResourceObserver: class
{
    func resourceChangedState(resource: SVResource)
}

public class SVResource: NSObject
{
    deinit
    {
        if let uniqueKey = self.uniqueKey
        {
            UniqueTable.table.removeValueForKey(uniqueKey)
        }
    }
    
    private class WeakHolder
    {
        var resource: SVResource?
    }
    
    private struct UniqueTable
    {
        static var table: [String:WeakHolder] = [:]
    }
    
    private var uniqueKey: String?
    
    class func retrieve<T:SVResource>(key: String, createFunction: () -> T) -> T
    {
        let uniqueKey = "\(NSStringFromClass(T))\(key)"
        
        if let weakHolder = UniqueTable.table[uniqueKey]
        {
            if let resource = weakHolder.resource
            {
                if let typedResource = resource as? T
                {
                    return typedResource
                }
            }
        }
        
        let resource = createFunction()
        resource.uniqueKey = uniqueKey
        
        let weakHolder = WeakHolder()
        weakHolder.resource = resource
        UniqueTable.table[uniqueKey] = weakHolder
        
        return resource
    }
    
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
