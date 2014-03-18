//
//  SVRemoteProxyResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteResource.h"

@protocol SVRemoteProxyResourceCompletionListener <NSObject>

-(void)remoteProxyResourceFinished;
-(void)remoteProxyResourceFailedToFinishWithError:(NSError*)error;

@end

#import "SVRemoteProxyResource.h"

/**
 SVRemoteProxyResource uses a second remote resource to load its data. Loading state and error state are propagated
 upwards from the proxied remote resource.
 */
@interface SVRemoteRetainedProxyResource : SVRemoteProxyResource

#pragma mark - Access
/**
 Retrieves a cached proxy remote resource with the given proxied resource and additional key, if one exists. Otherwise,
 returns nil.
 
 The additional key is a key to uniquely identify the proxy resource, among all possible proxy resources of the class
 that proxy the specified inner resource. There is no need to include the proxied resource's unique key - it is
 automatically included.
 
 Subclasses should provide their own accessors, as additional key generation for each remote proxy resource subclass
 should be an implementation detail of that class, and not externally visible.
 */
+(instancetype)cachedResourceProxyingResource:(SVRemoteResource*)proxiedResource
                            withAdditionalKey:(NSString*)additionalKey;

/**
 Retrieves or creates a proxy remote resource with the given proxied resource and additional key. This message must be
 sent to the proxy resource subclass.
 
 The additional key is a key to uniquely identify the proxy resource, among all possible proxy resources of the class
 that proxy the specified inner resource. There is no need to include the proxied resource's unique key - it is
 automatically included.
 
 If the resource is created, it will be passed to the initialization block (for ivar initialization). Otherwise, it
 will be simply returned.
 
 Subclasses should provide their own accessors, as additional key generation for each remote proxy resource subclass
 should be an implementation detail of that class, and not externally visible.
 */
+(instancetype)resourceProxyingResource:(SVRemoteResource*)proxiedResource
                      withAdditionalKey:(NSString*)additionalKey
                    initializationBlock:(void(^)(id resource))initializationBlock;

#pragma mark - Proxied Resource
/**
 The proxied resource.
 */
@property (nonatomic, readonly, strong) SVRemoteResource *proxiedResource;

#pragma mark - Subclass Implementation
/**
 Subclasses must override this message to parse the loaded proxy object.
 
 Messages to the listener object may be passed synchronously or asynchronously, but they must be passed on the main
 thread.
 
 The default implementation throws an exception.
 */
-(void)parseFinishedProxiedResource:(id)proxiedResource
                       withListener:(id<SVRemoteProxyResourceCompletionListener>)listener;

@end
