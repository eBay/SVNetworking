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

#import "SVRemoteResource.h"

/**
 Optionally asynchronous completion listener for SVRemoteProxyResource parsing.
 
 All completion listener messages should be passed on the main thread.
 */
@protocol SVRemoteProxyResourceCompletionListener <NSObject>

/**
 If parsing succeeds, pass this message to the completion listener.
 
 This message must be passed on the main thread.
 */
-(void)remoteProxyResourceFinished;

/**
 If parsing fails, pass this message to the completion listener with an appropriate error object.
 
 This message must be passed on the main thread.
 
 @param error The error that caused the parsing to fail. This parameter is optional.
 */
-(void)remoteProxyResourceFailedToFinishWithError:(NSError*)error;

@end

/**
 SVRemoteProxyResource uses a second remote resource to load its data. Loading state and error state are propagated
 upwards from the proxied remote resource.
 
 This direct subclasses of SVRemoteProxyResource will not automatically retain their
 */
@interface SVRemoteProxyResource : SVRemoteResource

#pragma mark - Subclass Implementation
/** @name Subclass Implementation */

/**
 Subclasses must override this message to provide a resource to load and proxy.
 
 It is not necessary to load the proxied resource - SVRemoteProxyResource will do this automatically.
 
 The default implementation will retain the proxied resource while it is loading, then release it upon loading success
 or failure. The proxied resource will be reacquired as is necessary for additional loading retry attempts.
 
 SVRemoteRetainedProxyResource provides an implementation that specifies the resource to proxy at initialization time,
 and returns it automatically.
 
 @warning The default implementation throws an exception.
 */
-(SVRemoteResource*)acquireProxiedResource;

/**
 Subclasses must override this message to parse the loaded proxy object.
 
 Messages to the listener object may be passed synchronously or asynchronously, but they must be passed on the main
 thread.
 
 @warning The default implementation throws an exception.
 @param proxiedResource The finished proxied resource.
 @param listener A completion listener.
 */
-(void)parseFinishedProxiedResource:(id)proxiedResource
                       withListener:(id<SVRemoteProxyResourceCompletionListener>)listener;

@end
