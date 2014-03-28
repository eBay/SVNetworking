//
//  SVRemoteProxyResource.h
//  
//
//  Created by Nate Stedman on 3/18/14.
//
//

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
