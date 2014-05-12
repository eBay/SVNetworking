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

#import "SVRemoteProxyResource.h"

@interface SVRemoteProxyResource () <SVRemoteProxyResourceCompletionListener>
{
@private
    SVRemoteResource *_acquiredProxyResource;
}

@end

@implementation SVRemoteProxyResource

-(void)dealloc
{
    if (_acquiredProxyResource)
    {
        [_acquiredProxyResource removeObserver:self forKeyPath:@"state"];
    }
}

#pragma mark - Loading
-(void)beginLoading
{
    // acquire the resource, if necessary
    if (!_acquiredProxyResource)
    {
        _acquiredProxyResource = [self acquireProxiedResource];
    }
    
    // keep the current resource around - it's possible that completion could cause the ivar to be changed
    SVRemoteResource *resource = _acquiredProxyResource;
    
    if (_acquiredProxyResource.state == SVRemoteResourceStateFinished)
    {
        // if the resource has already finished, we can proceed directly to completion
        [self finishLoadingProxiedResource];
        
        if (resource == _acquiredProxyResource)
        {
            _acquiredProxyResource = nil;
        }
    }
    else if (_acquiredProxyResource.state == SVRemoteResourceStateError)
    {
        // if the resource has already failed, we can proceed direectly to failure
        [self failLoadingWithError:_acquiredProxyResource.error];
        
        if (resource == _acquiredProxyResource)
        {
            _acquiredProxyResource = nil;
        }
    }
    else
    {
        // otherwise, wait for state changes and begin loading
        [_acquiredProxyResource addObserver:self forKeyPath:@"state" options:0 context:NULL];
        [_acquiredProxyResource beginLoading];
    }
}

-(void)finishLoadingProxiedResource
{
    [self parseFinishedProxiedResource:_acquiredProxyResource withListener:self];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _acquiredProxyResource && [keyPath isEqualToString:@"state"])
    {
        switch (_acquiredProxyResource.state)
        {
            case SVRemoteResourceStateError:
                // propagate the error to this resource
                [self failLoadingWithError:_acquiredProxyResource.error];
                
                // clean up KVO
                [object removeObserver:self forKeyPath:keyPath];
                
                // we need to confirm the ivar still points to the same object before clearing
                if (object == _acquiredProxyResource)
                {
                    _acquiredProxyResource = nil;
                }
                
                break;
                
            case SVRemoteResourceStateFinished:
                // parse finished state for this resource
                [self finishLoadingProxiedResource];
                
                // clean up KVO
                [object removeObserver:self forKeyPath:keyPath];
                
                // we need to confirm the ivar still points to the same object before clearing
                if (object == _acquiredProxyResource)
                {
                    _acquiredProxyResource = nil;
                }
                
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

#pragma mark - Remote Proxy Resource Completion Listener
-(void)remoteProxyResourceFinished
{
    [self finishLoading];
}

-(void)remoteProxyResourceFailedToFinishWithError:(NSError *)error
{
    [self failLoadingWithError:error];
}

#pragma mark - Subclass Implementation
-(SVRemoteResource*)acquireProxiedResource
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(void)parseFinishedProxiedResource:(id)proxiedResource
                       withListener:(id<SVRemoteProxyResourceCompletionListener>)listener
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
