//
//  SVRemoteDataResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteDataRequestResource.h"

@interface SVRemoteDataRequestResource () <SVDataRequestDelegate>
{
@private
    SVDataRequest *_request;
}

@end

@implementation SVRemoteDataRequestResource

#pragma mark - Data Request Delegate
-(void)request:(SVDataRequest *)request finishedWithData:(NSData *)data response:(NSHTTPURLResponse *)response
{
    [self finishLoadingWithData:data];
    _request = nil;
}

-(void)request:(SVRequest *)request failedWithError:(NSError *)error
{
    [self failLoadingWithError:error];
    _request = nil;
}

#pragma mark - Implementation
-(void)beginLoading
{
    // send loading request
    _request = [self requestForNetworkLoading];
    _request.delegate = self;
    [_request start];
}

-(void)finishLoadingWithData:(NSData*)data
{
    NSError *error = nil;
    [self parseFinishedData:data error:&error];
    
    if (error)
    {
        [self failLoadingWithError:error];
    }
    else
    {
        [self finishLoading];
    }
}

#pragma mark - Subclass Implementation
-(SVDataRequest*)requestForNetworkLoading
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Implementation
-(void)parseFinishedData:(NSData*)data error:(NSError**)error;
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
