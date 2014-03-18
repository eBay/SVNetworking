//
//  SVRemoteProxyResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "NSObject+SVBindings.h"
#import "SVRemoteRetainedProxyResource.h"

@implementation SVRemoteRetainedProxyResource

#pragma mark - Access
+(instancetype)cachedResourceProxyingResource:(SVRemoteResource*)proxiedResource
                            withAdditionalKey:(NSString*)additionalKey
{
    NSString *key = [NSString stringWithFormat:@"%@%@", proxiedResource.uniqueKeyHash, additionalKey];
    return [self cachedResourceWithUniqueKey:key];
}

+(instancetype)resourceProxyingResource:(SVRemoteResource*)proxiedResource
                      withAdditionalKey:(NSString*)additionalKey
                    initializationBlock:(void(^)(id resource))initializationBlock;
{
    NSString *key = [NSString stringWithFormat:@"%@%@", proxiedResource.uniqueKeyHash, additionalKey];
    
    return [self resourceWithUniqueKey:key withInitializationBlock:^(SVRemoteRetainedProxyResource *resource) {
        resource->_proxiedResource = proxiedResource;
        
        if (initializationBlock)
        {
            initializationBlock(resource);
        }
    }];
}

#pragma mark - Implementation
-(SVRemoteResource*)acquireProxiedResource
{
    return _proxiedResource;
}

@end
