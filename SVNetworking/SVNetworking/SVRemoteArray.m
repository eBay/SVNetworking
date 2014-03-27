//
//  SVRemoteArray.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/27/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteArray.h"

@interface SVRemoteArray ()
{
@private
    NSHashTable *_paginationObservers;
}

@end

@implementation SVRemoteArray

#pragma mark - Initialization
-(id)init
{
    self = [super init];
    
    if (self)
    {
        _paginationObservers = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
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

@end
