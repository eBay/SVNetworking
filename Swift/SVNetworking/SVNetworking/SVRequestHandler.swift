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

public class SVRequestHandler: NSObject
{
    // MARK: - Request
    public let request: SVRequest
    
    // MARK: - Initialization
    public init(request: SVRequest)
    {
        self.request = request
        
        super.init()
        
        self.request.completion = { [weak self] (data, response) in
            if let strongSelf = self
            {
                strongSelf.handleCompletionWithData(data, response: response)
            }
        }
        
        self.request.failure = { [weak self] (error, response) in
            if let strongSelf = self
            {
                strongSelf.handleFailureWithError(error, response: response)
            }
        }
    }
    
    // MARK: - Deinitialization
    deinit
    {
        request.completion = nil
        request.failure = nil
    }
    
    // MARK: - Subclass Implementation
    public func handleCompletionWithData(data: NSData, response: NSURLResponse)
    {
        fatalError("Subclasses of SVRequestHandler must override handleCompletionWithData:response:")
    }
    
    public func handleFailureWithError(error: NSError?, response: NSURLResponse)
    {
        fatalError("Subclasses of SVRequestHandler must override handleFailureWithError:response:")
    }
}
