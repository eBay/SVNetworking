//
//  SVRemoteProxyResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteProxyResource.h"

@implementation SVRemoteProxyResource

#pragma mark - Access
+(instancetype)cachedResourceProxyingResource:(SVRemoteResource*)proxiedResource
{
    return [self cachedResourceWithUniqueKey:proxiedResource.uniqueKeyHash];
}

+(instancetype)resourceProxyingResource:(SVRemoteResource*)proxiedResource
{
    return [self resourceWithUniqueKey:proxiedResource.uniqueKeyHash withInitializationBlock:^(SVRemoteProxyResource *resource) {
        resource->_proxiedResource = proxiedResource;
    }];
}

@end
