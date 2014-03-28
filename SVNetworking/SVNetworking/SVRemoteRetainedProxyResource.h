//
//  SVRemoteProxyResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteResource.h"
#import "SVRemoteProxyResource.h"

/**
 This abstract subclass of SVRemoteProxyResource retains a proxied resource upon initialization.
 
 Subclasses must override -parseFinishedProxiedResource:withListener: to handle proxy resource parsing.
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
 
 @param proxiedResource The resource to use for proxy loading.
 @param additionalKey A key to uniquely identify the proxy resource.
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
 
 @param proxiedResource The resource to use for proxy loading.
 @param additionalKey A key to uniquely identify the proxy resource.
 @param initializationBlock A block to initialize the newly created proxy resource.
 */
+(instancetype)resourceProxyingResource:(SVRemoteResource*)proxiedResource
                      withAdditionalKey:(NSString*)additionalKey
                    initializationBlock:(void(^)(id resource))initializationBlock;

#pragma mark - Proxied Resource
/**
 The proxied resource.
 */
@property (nonatomic, readonly, strong) SVRemoteResource *proxiedResource;

@end
