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

#import "SVRequest.h"

@class SVJSONRequest;

/**
 A delegate protocol for SVJSONRequest objects.
 */
@protocol SVJSONRequestDelegate <SVRequestDelegate>

/**
 Sent when the request finishes successfully.
 
 @param request The request.
 @param JSON The JSON loaded by the request.
 @param response The HTTP response received by the request.
 */
-(void)request:(SVRequest*)request finishedWithJSON:(id)JSON response:(NSHTTPURLResponse*)response;

@end

/**
 A request that loads JSON objects.
 */
@interface SVJSONRequest : SVRequest

/** @name Delegation */
/**
 The delegate for the request. */
@property (readwrite, weak) id<SVJSONRequestDelegate> delegate;

/** @name Parsing */
/**
 Parses a data object into JSON objects.
 
 Subclasses can override this message to provide custom error checking at the request level. For example, if your API
 specifies errors in a structured way (i.e. inside a `meta` object in JSON responses), you can check that, and report
 a request failure.
 
 @param data The data to parse.
 @param error An error pointer for parse failure.
 @returns A valid JSON object, or `nil`.
 */
-(id)parseJSONData:(NSData*)data error:(__autoreleasing NSError**)error;

@end
