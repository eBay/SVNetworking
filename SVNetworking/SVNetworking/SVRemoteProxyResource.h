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
+(instancetype)cachedResourceProxyingResource:(SVRemoteResource*)proxiedResource;
+(instancetype)resourceProxyingResource:(SVRemoteResource*)proxiedResource;

#pragma mark - Proxied Resource
@property (nonatomic, readonly, strong) id proxiedResource;

@end
