//
//  SVRemoteResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteResource.h"

@interface SVRemoteResource () <SVDataRequestDelegate>
{
@private
    SVDataRequest *_request;
}

#pragma mark - State
@property (nonatomic) SVRemoteResourceState state;

#pragma mark - Error
@property (nonatomic) NSError *error;

@end

@implementation SVRemoteResource

#pragma mark - Loading
-(void)load
{
    if (_state == SVRemoteResourceStateNotLoaded || _state == SVRemoteResourceStateError)
    {
        // update state
        self.state = SVRemoteResourceStateLoading;
        
        // send loading request
        _request = [self requestForLoading];
        _request.delegate = self;
        [_request start];
    }
}

#pragma mark - Data Request Delegate
-(void)request:(SVDataRequest *)request finishedWithData:(NSData *)data response:(NSHTTPURLResponse *)response
{
    NSError *error = nil;
    [self finishWithData:data error:&error];
    
    if (error)
    {
        self.error = error;
        self.state = SVRemoteResourceStateError;
    }
    else
    {
        self.state = SVRemoteResourceStateFinished;
    }
    
    _request = nil;
}

-(void)request:(SVRequest *)request failedWithError:(NSError *)error
{
    self.error = error;
    self.state = SVRemoteResourceStateError;
    
    _request = nil;
}

#pragma mark - Implementation
-(SVDataRequest*)requestForLoading
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(void)finishWithData:(NSData*)data error:(NSError**)error;
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
