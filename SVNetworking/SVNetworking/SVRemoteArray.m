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

#import "NSObject+SVBindings.h"
#import "SVFunctional.h"
#import "SVRemoteArray.h"

@interface SVRemoteArray ()
{
@private
    NSHashTable *_paginationObservers;
}

#pragma mark - Contents
@property (nonatomic, strong) NSArray *contents;

#pragma mark - Loading State
@property (nonatomic) SVRemoteArrayLoadingState nextPageLoadingState;
@property (nonatomic) SVRemoteArrayLoadingState refreshLoadingState;
@property (nonatomic) BOOL hasNextPage;

#pragma mark - Loading Errors
@property (nonatomic, strong) NSError *nextPageError;
@property (nonatomic, strong) NSError *refreshError;

@end

@implementation SVRemoteArray

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    
    if (self)
    {
        _contents = @[];
        _paginationObservers = [NSHashTable weakObjectsHashTable];
        _hasNextPage = YES;
    }
    
    return self;
}

#pragma mark - Element Access
-(id)objectAtIndexedSubscript:(NSUInteger)index
{
    return _contents[index];
}

-(NSUInteger)count
{
    return _contents.count;
}

#pragma mark - Loading
-(void)loadNextPage
{
    if (!self.isLoadingNextPage && self.hasNextPage)
    {
        // clear next page error if necessary
        if (_nextPageError)
        {
            self.nextPageError = nil;
        }
        
        // change loading state
        self.nextPageLoadingState = SVRemoteArrayLoadingStateLoading;
        
        // load the next page
        [self enumeratePaginationObservers:^(id<SVRemoteArrayPaginationObserver> paginationObserver) {
            if ([self respondsToSelector:@selector(remoteArrayWillBeginLoadingNextPage:)])
            {
                [paginationObserver remoteArrayWillBeginLoadingNextPage:self];
            }
        }];
        
        [self beginLoadingNextPage];
    }
}

-(void)refresh
{
    // we can only refresh if we've loaded the first page, or loaded an empty first page
    if (self.refreshable && (self.count > 0 || !self.hasNextPage) && !self.isRefreshing)
    {
        // clear refresh error if necessary
        if (_refreshError)
        {
            self.refreshError = nil;
        }
        
        // change loading state
        self.refreshLoadingState = SVRemoteArrayLoadingStateLoading;
        
        // refresh
        [self enumeratePaginationObservers:^(id<SVRemoteArrayPaginationObserver> paginationObserver) {
            if ([self respondsToSelector:@selector(remoteArrayWillBeginRefreshing:)])
            {
                [paginationObserver remoteArrayWillBeginRefreshing:self];
            }
        }];
        
        [self beginRefreshing];
    }
}

#pragma mark - Loading State
+(NSSet*)keyPathsForValuesAffectingIsLoadingNextPage
{
    return [NSSet setWithObject:SV_KEYPATH([SVRemoteArray new], nextPageLoadingState)];
}

-(BOOL)isLoadingNextPage
{
    return self.nextPageLoadingState == SVRemoteArrayLoadingStateLoading;
}

+(NSSet*)keyPathsForValuesAffectingIsRefreshing
{
    return [NSSet setWithObject:SV_KEYPATH([SVRemoteArray new], refreshLoadingState)];
}

-(BOOL)isRefreshing
{
    return self.refreshLoadingState == SVRemoteArrayLoadingStateLoading;
}

#pragma mark - Refreshability
-(BOOL)refreshable
{
    return YES;
}

#pragma mark - Pagination Observers
-(void)addPaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver
{
    [_paginationObservers addObject:paginationObserver];
}

-(void)removePaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver
{
    [_paginationObservers removeObject:paginationObserver];
}

-(void)enumeratePaginationObservers:(void(^)(id<SVRemoteArrayPaginationObserver> paginationObserver))block
{
    for (id<SVRemoteArrayPaginationObserver> paginationObserver in _paginationObservers)
    {
        block(paginationObserver);
    }
}

#pragma mark - Implementation - Abstract (Subclasses)
-(void)beginLoadingNextPage
{
    [self doesNotRecognizeSelector:_cmd];
}

-(void)beginRefreshing
{
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Implementation - Next Page
-(void)finishLoadingNextPageWithItems:(NSArray*)items hasNextPage:(BOOL)hasNextPage
{
    [self willChangeValueForKey:SV_KEYPATH(self, count)];
    self.contents = [self.contents arrayByAddingObjectsFromArray:items];
    [self didChangeValueForKey:SV_KEYPATH(self, count)];
    
    self.nextPageLoadingState = SVRemoteArrayLoadingStateNotLoading;
    
    if (_hasNextPage != hasNextPage)
    {
        self.hasNextPage = hasNextPage;
    }
    
    [self enumeratePaginationObservers:^(id<SVRemoteArrayPaginationObserver> paginationObserver) {
        if ([paginationObserver respondsToSelector:@selector(remoteArray:didLoadNextPageWithItems:hasNextPage:)])
        {
            [paginationObserver remoteArray:self didLoadNextPageWithItems:items hasNextPage:hasNextPage];
        }
    }];
}

-(void)failLoadingNextPageWithError:(NSError*)error
{
    self.nextPageError = error;
    self.nextPageLoadingState = SVRemoteArrayLoadingStateError;
    
    [self enumeratePaginationObservers:^(id<SVRemoteArrayPaginationObserver> paginationObserver) {
        if ([paginationObserver respondsToSelector:@selector(remoteArray:didFailToLoadNextPageWithError:)])
        {
            [paginationObserver remoteArray:self didFailToLoadNextPageWithError:error];
        }
    }];
}

#pragma mark - Implementation - Refresh
-(void)finishRefreshingWithItems:(NSArray*)items
{
    [self willChangeValueForKey:SV_KEYPATH(self, count)];
    self.contents = [items arrayByAddingObjectsFromArray:self.contents];
    [self didChangeValueForKey:SV_KEYPATH(self, count)];
    
    self.refreshLoadingState = SVRemoteArrayLoadingStateNotLoading;
    
    [self enumeratePaginationObservers:^(id<SVRemoteArrayPaginationObserver> paginationObserver) {
        if ([paginationObserver respondsToSelector:@selector(remoteArray:didRefreshWithItems:)])
        {
            [paginationObserver remoteArray:self didRefreshWithItems:items];
        }
    }];
}

-(void)failRefreshingWithError:(NSError*)error
{
    self.refreshError = error;
    self.refreshLoadingState = SVRemoteArrayLoadingStateError;
    
    [self enumeratePaginationObservers:^(id<SVRemoteArrayPaginationObserver> paginationObserver) {
        if ([paginationObserver respondsToSelector:@selector(remoteArray:didFailToRefreshWithError:)])
        {
            [paginationObserver remoteArray:self didFailToRefreshWithError:error];
        }
    }];
}

#pragma mark - Fast Enumeration
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_contents countByEnumeratingWithState:state objects:buffer count:len];
}

@end
