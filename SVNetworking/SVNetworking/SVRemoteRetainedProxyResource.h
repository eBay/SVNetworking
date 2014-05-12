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
