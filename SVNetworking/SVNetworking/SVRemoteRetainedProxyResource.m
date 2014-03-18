//
//  SVRemoteProxyResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "NSObject+SVBindings.h"
#import "SVRemoteRetainedProxyResource.h"

@interface SVRemoteRetainedProxyResource () <SVRemoteProxyResourceCompletionListener>

@end

@implementation SVRemoteRetainedProxyResource

#pragma mark - Deallocation
-(void)dealloc
{
    [self sv_unbindAll];
}

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

#pragma mark - Loading
-(void)beginLoading
{
    if (_proxiedResource.state == SVRemoteResourceStateFinished)
    {
        [self finishLoadingProxiedResource];
    }
    else
    {
        [_proxiedResource addObserver:self forKeyPath:@"state" options:0 context:NULL];
        [_proxiedResource beginLoading];
    }
}

-(void)finishLoadingProxiedResource
{
    [self parseFinishedProxiedResource:_proxiedResource withListener:self];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _proxiedResource && [keyPath isEqualToString:@"state"])
    {
        switch (_proxiedResource.state)
        {
            case SVRemoteResourceStateError:
                // propagate the error to this resource
                [self failLoadingWithError:_proxiedResource.error];
                
                // clean up KVO
                [_proxiedResource removeObserver:self forKeyPath:keyPath];
                
                break;
                
            case SVRemoteResourceStateFinished:
                // parse finished state for this resource
                [self finishLoadingProxiedResource];
                
                // clean up KVO
                [_proxiedResource removeObserver:self forKeyPath:keyPath];
                
                break;
            
            default:
                break;
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Subclass Implementation
-(void)parseFinishedProxiedResource:(id)proxiedResource
                       withListener:(id<SVRemoteProxyResourceCompletionListener>)listener
{
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Remote Proxy Resource Completion Listener
-(void)remoteProxyResourceFinished
{
    [self finishLoading];
}

-(void)remoteProxyResourceFailedToFinishWithError:(NSError *)error
{
    [self failLoadingWithError:error];
}

@end
