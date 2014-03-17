//
//  SVRemoteProxyResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "NSObject+SVBindings.h"
#import "SVRemoteProxyResource.h"

@implementation SVRemoteProxyResource

#pragma mark - Deallocation
-(void)dealloc
{
    [self sv_unbindAll];
}

#pragma mark - Access
+(instancetype)cachedResourceProxyingResource:(SVRemoteResource*)proxiedResource
                            withAdditionalKey:(NSString*)additionalKey
{
    return [self cachedResourceWithUniqueKey:proxiedResource.uniqueKeyHash];
}

+(instancetype)resourceProxyingResource:(SVRemoteResource*)proxiedResource
                      withAdditionalKey:(NSString*)additionalKey
                    initializationBlock:(void(^)(id resource))initializationBlock;
{
    return [self resourceWithUniqueKey:proxiedResource.uniqueKeyHash withInitializationBlock:^(SVRemoteProxyResource *resource) {
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
    NSError *error = nil;
    [self parseFinishedProxiedResource:_proxiedResource error:&error];
    
    if (error)
    {
        [self failLoadingWithError:error];
    }
    else
    {
        [self finishLoading];
    }
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
-(void)parseFinishedProxiedResource:(id)proxiedResource error:(NSError**)error
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
