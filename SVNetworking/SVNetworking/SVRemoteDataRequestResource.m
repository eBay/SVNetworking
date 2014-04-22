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
    _request = nil;
    [self finishLoadingWithData:data];
}

-(void)request:(SVRequest *)request failedWithError:(NSError *)error
{
    _request = nil;
    [self failLoadingWithError:error];
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
    BOOL success = [self parseFinishedData:data error:&error];
    
    if (success)
    {
        [self finishLoading];
    }
    else
    {
        [self failLoadingWithError:error];
    }
}

#pragma mark - Subclass Implementation
-(SVDataRequest*)requestForNetworkLoading
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Implementation
-(BOOL)parseFinishedData:(NSData*)data error:(__autoreleasing NSError**)error;
{
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

@end
