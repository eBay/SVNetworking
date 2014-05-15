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
