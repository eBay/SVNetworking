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

public class SVJSONRequestResource: SVRequestResource
{
    /**
    Instructs subclasses to parse JSON data. This function must be overridden.
    
    :param: JSON  The JSON data to parse.
    :param: error An error pointer to set if the JSON value is invalid.
    */
    public func parseFinishedJSON(JSON: SVJSON, error: NSErrorPointer) -> Bool
    {
        fatalError("Subclasses of SVJSONRequestResource must override parseFinishedJSON(:error)")
    }
    
    /**
    Triggers completion of a JSON object.
    
    It should not be necessary to override this function in a subclass.
    
    :param: JSON A JSON object.
    */
    public func finishLoadingWithJSON(JSON: SVJSON)
    {
        var error: NSError?
        
        if parseFinishedJSON(JSON, error: &error)
        {
            finishLoading()
        }
        else
        {
            failLoadingWithError(error)
        }
    }
    
    /**
    Returns a request JSON handler. Subclasses can use this function to return a customized handler that performs
    error checking against an API. It is not necessary to set `completion` or `failure` handlers, these will be
    overridden by this class anyways.
    
    :param: request The request to create a handler for.
    */
    public func JSONHandlerForRequest(request: SVRequest) -> SVRequestJSONHandler
    {
        return SVRequestJSONHandler(request: request)
    }
    
    public override func handlerForRequest(request: SVRequest) -> SVRequestHandler
    {
        let handler = JSONHandlerForRequest(request)
        
        handler.completion = { [weak self] (handler, JSON, response) in
            if let strongSelf = self
            {
                strongSelf.finishLoadingWithJSON(JSON)
            }
        }
        
        handler.failure = { [weak self] (handler, error, response) in
            if let strongSelf = self
            {
                strongSelf.failLoadingWithError(error)
            }
        }
        
        return handler
    }
}
