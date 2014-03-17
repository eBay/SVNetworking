//
//  SVRemoteJSONResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteJSONRequestResource.h"

@interface SVRemoteJSONRequestResource () <SVJSONRequestDelegate>
{
@private
    SVJSONRequest *_request;
}

@end

@implementation SVRemoteJSONRequestResource

#pragma mark - JSON Request Delegate
-(void)request:(SVDataRequest *)request finishedWithJSON:(id)JSON response:(NSHTTPURLResponse *)response
{
    [self finishLoadingWithJSON:JSON];
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

-(void)finishLoadingWithJSON:(id)JSON
{
    NSError *error = nil;
    [self parseFinishedJSON:JSON error:&error];
    
    if (error)
    {
        [self failLoadingWithError:error];
    }
    else
    {
        [self finishLoading];
    }
}

-(void)finishLoadingWithJSONData:(NSData*)JSONData
{
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (error)
    {
        [self failLoadingWithError:error];
    }
    else
    {
        [self finishLoadingWithJSON:JSON];
    }
}

#pragma mark - Subclass Implementation
-(SVJSONRequest*)requestForNetworkLoading
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(void)parseFinishedJSON:(id)JSON error:(NSError *__autoreleasing *)error
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
