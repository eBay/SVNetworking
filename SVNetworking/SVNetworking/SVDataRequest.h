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

@class SVDataRequest;

/**
 A delegate protocol for SVDataRequest objects.
 */
@protocol SVDataRequestDelegate <SVRequestDelegate>

/**
 Sent when the request finishes successfully.
 
 @param request The request.
 @param data The data object loaded by the request.
 @param response The HTTP response received by the request.
 */
-(void)request:(SVDataRequest*)request finishedWithData:(NSData*)data response:(NSHTTPURLResponse*)response;

@end

/**
 A request that loads data objects.
 */
@interface SVDataRequest : SVRequest

/**
 The delegate for the request.
 */
@property (readwrite, weak) id<SVDataRequestDelegate> delegate;

@end
