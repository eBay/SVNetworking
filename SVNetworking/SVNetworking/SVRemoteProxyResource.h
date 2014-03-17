//
//  SVRemoteProxyResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteResource.h"

@interface SVRemoteProxyResource : SVRemoteResource

#pragma mark - Access
+(instancetype)cachedResourceProxyingResource:(SVRemoteResource*)proxiedResource
                            withAdditionalKey:(NSString*)additionalKey;
+(instancetype)resourceProxyingResource:(SVRemoteResource*)proxiedResource
                      withAdditionalKey:(NSString*)additionalKey
                    initializationBlock:(void(^)(id resource))initializationBlock;

#pragma mark - Proxied Resource
@property (nonatomic, readonly, strong) SVRemoteResource *proxiedResource;

#pragma mark - Subclass Implementation
-(void)parseFinishedProxiedResource:(id)proxiedResource error:(NSError**)error;

@end
