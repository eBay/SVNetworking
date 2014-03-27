//
//  SVRemoteArray.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/27/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

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
@property (nonatomic) BOOL isLoadingNextPage;
@property (nonatomic) BOOL isRefreshing;
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
        
        // load the next page
        [self beginLoadingNextPage];
    }
}

-(void)refresh
{
    // we can only refresh if we've loaded the first page, or loaded an empty first page
    if ((self.count > 0 || !self.hasNextPage) && !self.isRefreshing)
    {
        // clear refresh error if necessary
        if (_refreshError)
        {
            self.refreshError = nil;
        }
        
        // refresh
        [self beginRefreshing];
    }
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
    self.isLoadingNextPage = NO;
    
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
    
    self.isRefreshing = NO;
    
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
    self.isRefreshing = NO;
    
    [self enumeratePaginationObservers:^(id<SVRemoteArrayPaginationObserver> paginationObserver) {
        if ([paginationObserver respondsToSelector:@selector(remoteArray:didFailToRefreshWithError:)])
        {
            [paginationObserver remoteArray:self didFailToRefreshWithError:error];
        }
    }];
}

@end
