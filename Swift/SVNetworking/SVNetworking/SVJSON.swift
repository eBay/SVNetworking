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

public class SVJSON: NSObject
{
    public let root: AnyObject
    
    public init(root: AnyObject)
    {
        self.root = root
    }
    
    public var string: String? {
        return root as? String
    }
    
    public var number: NSNumber? {
        return root as? NSNumber
    }
    
    public var int: Int? {
        return number?.integerValue
    }
    
    public var double: Double? {
        return number?.doubleValue
    }
    
    public var float: Float? {
        return number?.floatValue
    }
    
    public var object: [String:SVJSON]? {
        return (root as? [String:AnyObject]).map {
            var object: [String:SVJSON] = [:]
            
            for (key, value) in $0
            {
                object[key] = SVJSON(root: value)
            }
            
            return object
        }
    }
    
    public var array: [SVJSON]? {
        return (root as? [AnyObject]).map { (array) in
            return array.map({ (object) in
                return SVJSON(root: object)
            })
        }
    }
}
