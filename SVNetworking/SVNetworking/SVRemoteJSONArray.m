//
//  SVRemoteJSONArray.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/27/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteJSONArray.h"

@interface SVRemoteJSONArray () <SVJSONRequestDelegate>
{
@private
    SVJSONRequest *_nextPageRequest;
    SVJSONRequest *_refreshRequest;
}

@end

@implementation SVRemoteJSONArray

#pragma mark - Implementation - Overrides
-(void)beginLoadingNextPage
{
    _nextPageRequest = [self buildNextPageRequest];
    _nextPageRequest.delegate = self;
    [_nextPageRequest start];
}

-(void)beginRefreshing
{
    _refreshRequest = [self buildRefreshRequest];
    _refreshRequest.delegate = self;
    [_refreshRequest start];
}

#pragma mark - Requests - Abstract
-(SVJSONRequest*)buildRequest
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Requests
-(SVJSONRequest*)buildNextPageRequest
{
    return [self buildRequest];
}

-(SVJSONRequest*)buildRefreshRequest
{
    return [self buildRequest];
}

#pragma mark - Parsing
-(BOOL)checkJSON:(NSDictionary*)JSON error:(__autoreleasing NSError**)error
{
    return YES;
}

#pragma mark - Parsing - Abstract
-(NSArray*)itemsForJSON:(NSDictionary*)JSON withLoadingType:(SVRemoteJSONArrayLoadingType)loadingType
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(BOOL)hasNextPageForJSON:(NSDictionary*)JSON withParsedItems:(NSArray*)items
{
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

#pragma mark - Request Delegate
-(void)request:(SVRequest *)request finishedWithJSON:(id)JSON response:(NSHTTPURLResponse *)response
{
    NSError *error = nil;
    
    if ([self checkJSON:JSON error:&error])
    {
        if (request == _nextPageRequest)
        {
            _nextPageRequest = nil;
            
            NSArray *items = [self itemsForJSON:JSON withLoadingType:SVRemoteJSONArrayLoadingTypeNextPage];
            BOOL hasNextPage = [self hasNextPageForJSON:JSON withParsedItems:items];
            [self finishLoadingNextPageWithItems:items hasNextPage:hasNextPage];
        }
        else if (request == _refreshRequest)
        {
            _refreshRequest = nil;
            
            NSArray *items = [self itemsForJSON:JSON withLoadingType:SVRemoteJSONArrayLoadingTypeRefresh];
            [self finishRefreshingWithItems:items];
        }
    }
    else
    {
        if (request == _nextPageRequest)
        {
            _nextPageRequest = nil;
            [self failLoadingNextPageWithError:error];
        }
        else if (request == _refreshRequest)
        {
            _refreshRequest = nil;
            [self failRefreshingWithError:error];
        }
    }
}

-(void)request:(SVRequest *)request failedWithError:(NSError *)error
{
    if (request == _nextPageRequest)
    {
        _nextPageRequest = nil;
        [self failLoadingNextPageWithError:error];
    }
    else if (request == _refreshRequest)
    {
        _refreshRequest = nil;
        [self failRefreshingWithError:error];
    }
}

@end
