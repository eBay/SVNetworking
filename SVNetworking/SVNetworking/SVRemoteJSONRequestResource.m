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
    _request = nil;
    [self finishLoadingWithJSON:JSON];
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

-(void)finishLoadingWithJSON:(id)JSON
{
    NSError *error = nil;
    BOOL success = [self parseFinishedJSON:JSON error:&error];
    
    if (success)
    {
        [self finishLoading];
    }
    else
    {
        [self failLoadingWithError:error];
    }
}

-(void)finishLoadingWithJSONData:(NSData*)JSONData
{
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (JSON)
    {
        [self finishLoadingWithJSON:JSON];
    }
    else
    {
        [self failLoadingWithError:error];
    }
}

#pragma mark - Subclass Implementation
-(SVJSONRequest*)requestForNetworkLoading
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(BOOL)parseFinishedJSON:(id)JSON error:(NSError *__autoreleasing *)error
{
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

@end
